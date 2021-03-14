import 'package:flutter/material.dart';
import 'package:noise_wave/app/widget/wave.dart';
import 'package:noise_wave/fx_entry.dart';
import 'package:noise_wave/fx_renderer.dart';
import 'package:noise_wave/touchpoint_notification.dart';

class NoiseWaveDemo extends StatefulWidget {
  static final List<FXEntry> fxs = [
    FXEntry("noiseWave", create: ({size}) => Wave(size: size))
  ];
  NoiseWaveDemo({Key key}) : super(key: key);

  @override
  _NoiseWaveDemoState createState() => _NoiseWaveDemoState();
}

class _NoiseWaveDemoState extends State<NoiseWaveDemo>
    with TickerProviderStateMixin {
  AnimationController _textController;

  @override
  void initState() {
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Listenable.merge([_textController]).addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(children: <Widget>[
          Opacity(
            opacity: 1.0,
            child: NotificationListener<TouchPointChangeNotification>(
              onNotification: _handleInteraction,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return FxRenderer(
                    fx: NoiseWaveDemo.fxs[0],
                    size: constraints.biggest,
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  bool _handleInteraction(TouchPointChangeNotification notification) {
    if (_textController.velocity <= 0) {
      _textController.forward();
    }
    return false;
  }
}
