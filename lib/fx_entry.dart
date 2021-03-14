import 'package:flutter/material.dart';
import 'package:noise_wave/app/widget/pixel_fx.dart';

class FXEntry {
  PixcelFX Function({Size size}) create;
  String name;
  ImageProvider icon;

  FXEntry(this.name, {@required this.create, this.icon});
}
