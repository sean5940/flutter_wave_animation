import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fast_noise/fast_noise.dart' as fast;
import 'package:flutter/material.dart';
import 'package:noise_wave/util/pixel_helpers.dart' as util;
import 'package:vector_math/vector_math_64.dart';

abstract class PixcelFX with ChangeNotifier {
  /*
    내폰
    pixelSize = 6
    pixelSpace = 1.2;
    zoffValue = 0.5
    frequency = 0.17

   */
  final double pixelSize = 4;
  final double pixelSpace = 1;
  final double zoffValue = 0.9;
  final double frequency = 0.08;

  int width;
  int height;
  int length;

  Offset touchPoint;
  Offset center;

  List<Pixcel> pixels;
  Int32List colors;
  Float32List xy;
  ui.Vertices vertices;

  var _noise;

  double _zoff;

  PixcelFX({@required Size size}) {
    width = ((size.width.round()) / (pixelSize * pixelSpace)).round();
    height = ((size.height.round()) / (pixelSize * pixelSpace)).round();
    length = width * height;
    xy = Float32List(12 * length);
    colors = Int32List(6 * length);
    pixels = []..length = this.length;
    center = Offset(width / 2, height / 2);

    _noise = new fast.CellularNoise(
        octaves: 1,
        frequency: frequency,
        cellularReturnType: fast.CellularReturnType.Distance2Mul);
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
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        pixels[index] = new Pixcel(
            x: col * pixelSize * pixelSpace, y: row * pixelSize * pixelSpace);
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

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        double luminance =
            _noise.getCellular3(col.toDouble(), row.toDouble(), _zoff);

        // luminance = smoothStep(-2.15, 0.5, luminance);
        luminance = smoothStep(-2.5, 0.3, luminance);

        int color =
            HSLColor.fromAHSL(1.0, 182, luminance, luminance).toColor().value;
        util.injectColor(index, colors, color);

        index++;
      }
    }
    _zoff = _zoff < 10000000 ? _zoff + zoffValue : _zoff - zoffValue;
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
