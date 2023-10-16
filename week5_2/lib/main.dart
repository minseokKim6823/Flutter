import 'package:flutter/material.dart';
import 'package:week5_2/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunflower',
        textTheme:const TextTheme(
          displayLarge: const TextStyle(
            color: Colors.white,
            fontSize: 30.0
          ),
          displaySmall: TextStyle(
            color: Colors.white,fontSize: 25.0,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,fontSize: 30.0,
          ),
          bodySmall: TextStyle(
            color:Colors.white,fontSize: 20.0,
          ),
        )
      ),
      home: HomeScreen(),
    ),
  );
}