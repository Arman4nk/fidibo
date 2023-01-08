import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moving Dot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DotScreen(),
    );
  }
}

class DotScreen extends StatefulWidget {
  const DotScreen({Key? key}) : super(key: key);

  @override
  State<DotScreen> createState() => _DotScreenState();
}

class _DotScreenState extends State<DotScreen> {
  final double _circleSize = 100;
  Offset? _circlePosition;
  double _slope = 0;
  double _xDistance = 0;
  int _tapCount = 0;

  Offset? _startData;
  Offset? _endData;

  late int imageID;

  void moveRight(double slope, int i) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (_tapCount != i) {
        timer.cancel();
//Stop moving in this direction when the screen is tapped again
      }
      _xDistance = sqrt(1 / (1 + pow(slope, 2)));
      setState(() {
        _circlePosition = Offset(_circlePosition!.dx + _xDistance,
            _circlePosition!.dy - slope * _xDistance);
      });

//if the ball bounces off the top or bottom

      if (_circlePosition!.dy < 0 ||
          _circlePosition!.dy >
              MediaQuery.of(context).size.height - _circleSize) {
        timer.cancel();
        moveRight(-slope, i);
      }
//if the ball bounces off the right
      if (_circlePosition!.dx >
          MediaQuery.of(context).size.width - _circleSize) {
        timer.cancel();
        moveLeft(-slope, i);
      }
    });
  }

  void moveLeft(double slope, int i) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (_tapCount != i) {
        timer.cancel();
//Stop moving in this direction when the screen is tapped again

      }
      _xDistance = sqrt(1 / (1 + pow(slope, 2)));
      setState(() {
        _circlePosition = Offset(_circlePosition!.dx - _xDistance,
            _circlePosition!.dy + slope * _xDistance);
      });

//if the ball bounces off the top or bottom
      if (_circlePosition!.dy < 0 ||
          _circlePosition!.dy >
              MediaQuery.of(context).size.height - _circleSize) {
        timer.cancel();
        moveLeft(-slope, i);
      }
//if the ball bounces off the left
      if (_circlePosition!.dx < 0) {
        timer.cancel();
        moveRight(-slope, i);
      }
    });
  }

  @override
  void initState() {
    imageID = 1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _circlePosition ??= Offset(
        (MediaQuery.of(context).size.width - _circleSize) / 2,
        (MediaQuery.of(context).size.height - _circleSize) / 2);
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              _startData = details.globalPosition;
            },
            onPanUpdate: (details) {
              _endData = details.globalPosition;
            },
            onPanEnd: (details) {
              if (_startData != null && _endData != null) {
                _tapCount++;
                _slope = (-_endData!.dy + _startData!.dy) /
                    (_endData!.dx - _startData!.dx);
                if (_endData!.dx < _startData!.dx) {
                  moveLeft(_slope, _tapCount);
                }
                if (_endData!.dx > _startData!.dx) {
                  moveRight(_slope, _tapCount);
                }
              }

            },
          ),
          Positioned(
            left: _circlePosition!.dx,
            top: _circlePosition!.dy,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  imageID = (Random().nextInt(26) + 1);
                });
              },
              child: Image.network(
                'https://picsum.photos/${_circleSize.toInt()}?random=$imageID',
              //  loadingBuilder: (context, child, loadingProgress) => const CircularProgressIndicator(),
                height: _circleSize,
                width: _circleSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
