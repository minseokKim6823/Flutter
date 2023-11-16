import 'package:flutter/material.dart';
import 'package:week10_lec/const/colors.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

class _Time extends StatelessWidget{
  final int startTime;
  final int endTime;
  final String content;

  const _Time({
    required this.startTime,
    required this.endTime,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );
    return Column( // ➌ 시간을 위에서 아래로 배치
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:00', // 숫자가 두 자리수가 안 되면 0으로 채워주기
          style: textStyle,
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:00', // 숫자가 두 자리수가 안 되면 0으로 채워주기
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content; // ➊ 내용
  const _Content({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded( // ➋ 최대한 넓게 늘리기
      child: Text(
        content,
      ),
    );
  }
}
