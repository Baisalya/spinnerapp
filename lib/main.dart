import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fortune Wheel Example',
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  StreamController<int> selected = StreamController<int>();
  List<String> items = [
    '₹0',
    '₹800',
    '₹300',
    '₹10',
    '₹100',
    '₹500',
    '₹1000',
  ];
  int selectedIndex = 0;
  bool spinning = false;
  int totalReward = 0;

  @override
  void initState() {
    super.initState();
    // Spin the wheel automatically when the app is opened
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  void spinWheel() {
    if (!spinning) {
      setState(() {
        spinning = true;
        selectedIndex = Fortune.randomInt(0, items.length);
        selected.add(selectedIndex);
      });

      // Simulate spinning time
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          spinning = false;
          totalReward += int.parse(items[selectedIndex].substring(1)); // Update total reward
        });
        // Show the result after spinning stops
        showResult();
      });
    }
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You Win!'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selected: ${items[selectedIndex]}'),
              Text('Total Reward: ₹$totalReward'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                spinWheel();
              },
              child: Text('Spin Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Fortune Wheel'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: GestureDetector(
              onTap: spinWheel,
              child: FortuneWheel(
                selected: selected.stream,
                indicators: <FortuneIndicator>[
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: TriangleIndicator(
                      color: Colors.yellowAccent,
                    ),
                  ),
                ],
                items: [
                  for (var it in items)
                    FortuneItem(
                      child: Text(it),
                      style: FortuneItemStyle(
                        color: Colors.redAccent,
                        borderColor: Colors.blueGrey,
                        borderWidth: 3,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              spinWheel();
            },
            child: Text('Spin Again'),
          ),
        ],
      ),
    );
  }

}
