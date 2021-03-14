import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noise_wave/app/widget/pixel_fx.dart';
import 'package:vector_math/vector_math_64.dart' as vMath;

// Renders a ParticleFX.
class PixcelFXPainter extends CustomPainter {
  PixcelFX fx;

  // ParticleFX is a ChangeNotifier, so we can use it as the repaint notifier.
  PixcelFXPainter({
    @required this.fx,
  }) : super(repaint: fx);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.transform(vMath.Matrix4.rotationX(1).storage);
    if (fx.vertices == null) {
      return;
    }
    Paint paint = Paint();
    canvas.drawVertices(fx.vertices, BlendMode.dst, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
