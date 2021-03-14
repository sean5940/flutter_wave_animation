import 'package:flutter/material.dart';
import 'package:noise_wave/app/widget/pixel_fx.dart';

class Wave extends PixcelFX {
  Wave({@required Size size}) : super(size: size);

  @override
  void tick(Duration duration) {
    if (pixels[0] == null) {
      fillInitialData();
    }
    injectColor();

    super.tick(duration);
  }
}
