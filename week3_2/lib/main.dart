import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isBoxVisible = true;

  void toggleVisibility() {
    setState(() {
      isBoxVisible = !isBoxVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        toggleVisibility();
      },
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (isBoxVisible)
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                width: 100.0,
                height: 100.0,
              ),
            if (!isBoxVisible)
              Text(
                '클릭함',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 20),
                      const Offset(300, 20),
                      <Color>[
                        Colors.blue,
                        Colors.yellow,
                      ],
                    ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
