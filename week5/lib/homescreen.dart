import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({Key? key}): super(key: key);
  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: PageView(
        children: [1,2,3,4,5,6]
          .map(
              (number) => Image.asset('asset/img/img$number.jpg',
              fit:BoxFit.cover,
              ),
        ).toList(),
      ),
    );
  }
}