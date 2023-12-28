import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fortune Wheel'),
        ),
        body: Center(
          child: FortuneWheel(),
        ),
      ),
    );
  }
}

class FortuneWheel extends StatefulWidget {
  @override
  _FortuneWheelState createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<int> values = [100, 200, 300, 55, 500];
  double angle = 0.0;
  bool isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.yellow,
                    Colors.purple,
                  ],
                ),
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: angle,
                    child: child,
                  );
                },
                child: CustomPaint(
                  painter: WheelPainter(values.length),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Icon(
                Icons.arrow_upward,
                size: 30,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (!isSpinning) {
              startSpinning();
            }
          },
          child: Text('Spin the Wheel'),
        ),
        SizedBox(height: 20),
        Text('Result: ${getResult()}'),
      ],
    );
  }

  void startSpinning() {
    isSpinning = true;
    _controller.forward(from: 0.0);
    spinWheel();

    // Spin for 3 seconds, then stop
    Timer(Duration(seconds: 3), () {
      stopSpinning();
    });
  }

  void stopSpinning() {
    isSpinning = false;
    setState(() {
      angle = Random().nextDouble() * 2 * pi;
    });
  }

  String getResult() {
    int index = ((angle / (2 * pi)) * values.length).floor() % values.length;
    return values[index].toString();
  }

  void spinWheel() {
    setState(() {
      angle += 0.1; // Adjust the speed of spinning
    });

    if (isSpinning) {
      Future.delayed(Duration(milliseconds: 16), spinWheel);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WheelPainter extends CustomPainter {
  final int numOfSections;

  WheelPainter(this.numOfSections);

  @override
  void paint(Canvas canvas, Size size) {
    double sectionAngle = 2 * pi / numOfSections;
    double startAngle = 0;

    for (int i = 0; i < numOfSections; i++) {
      Paint paint = Paint()
        ..color = getColor(i)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
        startAngle,
        sectionAngle,
        true,
        paint,
      );

      startAngle += sectionAngle;
    }
  }

  Color getColor(int index) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ];

    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
