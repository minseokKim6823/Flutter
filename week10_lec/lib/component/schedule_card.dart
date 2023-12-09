import 'package:firebase_auth/firebase_auth.dart';
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
  String? _userEmail;
  List<String> _loggedInUserEmails = [];

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // 사용자의 이메일을 초기화할 때 가져오도록 호출
  }

  Future<void> _loadUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
    }
  }

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
              _Members(
                members: _membersCount,
                loggedInUserEmails: _loggedInUserEmails, // 여기서 매개변수를 전달
              ),
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
        _addCurrentUserEmail();
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

  void _addCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String currentUserEmail = user.email!;
      if (!_loggedInUserEmails.contains(currentUserEmail)) {
        _loggedInUserEmails.add(currentUserEmail);
        print("참여한 사용자 이메일 추가: $currentUserEmail");
      } else {
        // Show a dialog when the email is already in the list
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('중복된 이메일'),
              content: Text('이미 참여한 사용자입니다.'),
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
}

class _Members extends StatelessWidget {
  final int members;
  final List<String> loggedInUserEmails;

  const _Members({
    required this.members,
    required this.loggedInUserEmails,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userList = loggedInUserEmails.join(', ');
    return Positioned(
      child: Text(
        '멤버 수: ${loggedInUserEmails.length} 명 (최대 10명)}',
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
