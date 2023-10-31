import 'package:flutter/material.dart';

class PokemonScreen extends StatelessWidget{
  const PokemonScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset('asset/img/poke1.png'),
        ),
        SizedBox(height:32.0),
        Text(
          '아래버튼 클릭',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height:12.0),
      ],
    );
  }
}