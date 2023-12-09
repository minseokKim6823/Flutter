import 'package:flutter/material.dart';
import 'package:week10_lec/const/colors.dart';

class ScheduleCard extends StatefulWidget {
  final int startTime;
  final int endTime;
  final int member;
  final String content;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  int _membersCount = 0;

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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(
                startTime: widget.startTime,
                endTime: widget.endTime,
              ),
              SizedBox(width: 16.0),
              _Content(
                content: widget.content,
              ),
              SizedBox(width: 16.0),
              _Members(members: _membersCount),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () => _incrementMembers(context),
                child: Text('참여하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _incrementMembers(BuildContext context) {
    if (_membersCount < 10) {
      setState(() {
        _membersCount++;
      });
    } else {
      // Show a dialog when the limit is reached
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('최대 인원 초과'),
            content: Text('현재 최대 참여 가능한 인원은 10명입니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }
}

class _Members extends StatelessWidget {
  final int members;

  const _Members({
    required this.members,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Text(
        '멤버 수: $members 명 (최대 10명)',
        style: TextStyle(
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:00',
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(content),
    );
  }
}
