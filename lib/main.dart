import 'package:flutter/material.dart';
import 'package:noise_wave/demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "TitilliumWeb"),
      home: NoiseWaveDemo(),
    );
  }
}
