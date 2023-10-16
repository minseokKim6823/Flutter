import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(),
            _GersImage(),
          ],
        ),
      ),
    );
  }
}
class _DDay extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final textTheme =Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: 16.0),Text("I&GERS",style: textTheme.displayMedium,),
        const SizedBox(height: 16.0),Text("우리가 처음 만난 날",style: textTheme.displaySmall),
        const SizedBox(height: 16.0),Text("2015.10.7",style:textTheme.displaySmall),
        const SizedBox(height: 16.0),
        IconButton(
          iconSize: 50,
          color:Colors.pink,
          onPressed:(){},
          icon: Icon(Icons.favorite,),
        ),
        const SizedBox(height: 16.0),Text('D+365',style: textTheme.displaySmall),
      ]
    );
  }
}

class _GersImage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Expanded(
        child:Center(
            child: Image.asset(
              'asset/img/gers2.png',
              height: MediaQuery
                  .of(context)
                  .size
                  .height/2,
            )
        )
    );
  }
}