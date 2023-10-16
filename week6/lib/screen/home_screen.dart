import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}):super(key: key);
  @override
  State<HomeScreen> crateState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  DateTime firstDay = DateTime.now();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body:SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      )
    );
  }
}