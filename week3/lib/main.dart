import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
  //runApp(FloatingActionButtonExample());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body:Center(
          child:Text("SMART MOBILE PROGRAMMING",
            style:TextStyle(
              
              color: Colors.yellowAccent,

            ),
          )
        )
      )
    );
  }
}

// class FloatingActionButtonExample extends StatelessWidget{
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       home: Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           child: Text('클릭'),
//         ),
//         body: Container(),
//       ),
//     );
//   }
// }