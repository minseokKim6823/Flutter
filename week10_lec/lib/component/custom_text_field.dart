import 'package:flutter/material.dart';
import 'package:week10_lec/const/colors.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime; //시간 입력용인가?


  const CustomTextField({
    required this.label,
    required this.isTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column( // ➋ 세로로 텍스트와 텍스트 필드를 위치
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: isTime? 0:1,
          child: TextFormField(
            cursorColor: Colors.grey,
            maxLines: isTime? 1:null,
            expands: !isTime,
            keyboardType: isTime? TextInputType.number: TextInputType.multiline,
            inputFormatters: isTime?[
              FilteringTextInputFormatter.digitsOnly,
            ]:[],
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300],
              suffixText: isTime? '시':null,
            ),
          ),
        )
      ],
    );
  }
}

