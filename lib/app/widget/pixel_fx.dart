import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fast_noise/fast_noise.dart' as fast;
import 'package:flutter/material.dart';
import 'package:noise_wave/util/pixel_helpers.dart' as util;
import 'package:vector_math/vector_math_64.dart';

abstract class PixcelFX with ChangeNotifier {
  final double baseColor;
  final double increment;
  final double frequency;
  final double pixelSpace;
  final double pixcelSize;
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

  PixcelFX(
      {@required Size size,
      double baseColor = 210,
      double frequency = 0.2,
      double pixelSpace = 1.5,
      double pixelSize = 15,
      double increment = 0.08})
      : this.baseColor = baseColor,
        this.frequency = frequency,
        this.pixcelSize = pixelSize,
        this.pixelSpace = pixelSpace,
        this.increment = increment {
    width = ((size.width) / (pixcelSize + pixelSpace)).round();
    height = ((size.height) / (pixcelSize + pixelSpace)).round();

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
    calcWave();
  }

  void calcWave() {
    int index = 0;

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        double luminance =
            _noise.getCellular3(col.toDouble(), row.toDouble(), _zoff);

        luminance = smoothStep(-2.5, 0.5, luminance);

        double x = 0;
        double y = 0;
        if (index != 0) {
          x = index % width == 0
              ? 0
              : pixels[index - 1].x + pixels[index - 1].size;
          y = index - width < 0
              ? 0
              : pixels[index - width].y + pixels[index - width].size;
        }
        x += pixelSpace;
        y += pixelSpace;

        pixels[index] = new Pixcel(x, y, pixcelSize);

        util.injectVertex(index, xy, pixels[index].x, pixels[index].y,
            pixels[index].x + pixcelSize, pixels[index].y + pixcelSize);

        int color = HSLColor.fromAHSL(1.0, baseColor, luminance, luminance)
            .toColor()
            .value;
        util.injectColor(index, colors, color);

        index++;
      }
    }
    _zoff = _zoff < 10000000 ? _zoff + increment : _zoff - increment;
  }

  void tick(Duration duration) {
    vertices = ui.Vertices.raw(VertexMode.triangles, xy, colors: colors);
    notifyListeners();
  }
}

class Pixcel {
  final double x;
  final double y;
  final double size;

  Pixcel(this.x, this.y, this.size);
}
