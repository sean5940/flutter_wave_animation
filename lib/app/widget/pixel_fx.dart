import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:noise_wave/util/pixel_helpers.dart' as util;
import 'package:vector_math/vector_math_64.dart' as vMath;

abstract class PixcelFX with ChangeNotifier {
  final double pixelSize = 2.0;
  final double _increment = 0.015;

  double width;
  double height;
  int length;

  Offset touchPoint;
  Offset center;

  List<Pixcel> pixels;
  Int32List colors;
  Float32List xy;
  ui.Vertices vertices;

  vMath.SimplexNoise _simpleNoise;

  double _zoff;

  PixcelFX({@required Size size}) {
    width = size.width;
    height = size.height;
    length = ((width - 3) * (height - 3)).round();
    xy = Float32List(12 * length);
    colors = Int32List(6 * length);
    pixels = []..length = this.length;
    center = Offset(width / 2, height / 2);

    _simpleNoise = new vMath.SimplexNoise();
    _zoff = 0.0;
  }

  // Fills in the Particle list, and resets each Particle.
  // Override to add more capability if needed.
  void fillInitialData() {
    initPixel();
    initPosition();
    injectColor();
  }

  void initPixel() {
    int index = 0;
    for (int row = 0; row < height - 3; row++) {
      for (int col = 0; col < width - 3; col++) {
        pixels[index] = new Pixcel(x: col * pixelSize, y: row * pixelSize);
        index++;
      }
    }
  }

  void initPosition() {
    for (int i = 0; i < length; i++) {
      util.injectVertex(i, xy, pixels[i].x, pixels[i].y,
          pixels[i].x + pixelSize, pixels[i].y + pixelSize);
    }
  }

  void injectColor() {
    int index = 0;
    double _xoff = 0.0;

    for (int row = 0; row < height - 3; row++) {
      _xoff += _increment;
      double _yoff = 0.0;
      for (int col = 0; col < width - 3; col++) {
        double luminance = _simpleNoise.noise3D(_xoff, _yoff, _zoff);
        double saturation = vMath.smoothStep(0.0, 3.0, luminance);
        double lightness = vMath.smoothStep(-3.0, 2.0, luminance);
        int color =
            HSLColor.fromAHSL(1.0, 250, saturation, lightness).toColor().value;

        util.injectColor(index, colors, color);

        _yoff += _increment;
        index++;
      }
    }
    _zoff += 0.02;
  }

  void tick(Duration duration) {
    vertices = ui.Vertices.raw(VertexMode.triangles, xy, colors: colors);
    notifyListeners();
  }
}

class Pixcel {
  double x;
  double y;

  Pixcel({@required double x, @required double y}) {
    this.x = x;
    this.y = y;
  }
}
