import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:week6/screen/video_page.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime firstDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(
              onCakePressed: onCakePressed,
              firstDay: firstDay,
            ),
            _CharImage(
              onImageClicked1: onImageClicked1,
              onImageClicked2: onImageClicked2,
              onImageClicked3: onImageClicked3,
            ),// 이미지 클릭 핸들러 추가
          ],
        ),
      ),
    );
  }

  void onCakePressed() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime date) {
                setState(() {
                  firstDay = date;
                });
              },
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }

  // 이미지 클릭 핸들러
  void onImageClicked1() {
    setState(() {
      firstDay = DateTime(
        2013,
        12,
        31,
      );

    });
  }

  // 두 번째 이미지 클릭 핸들러
  void onImageClicked2() {
    setState(() {
      firstDay = DateTime(
        2013,
        12,
        28,
      );
    });
  }
  void onImageClicked3() {
    setState(() {
      final random = Random();
      // 'firstDay' 값을 랜덤한 날짜로 변경
      firstDay = DateTime(
        2018, 8, 8,
      );
    });
  }
}

class _DDay extends StatelessWidget {
  final GestureTapCallback onCakePressed;
  final DateTime firstDay;

  _DDay({
    required this.onCakePressed,
    required this.firstDay,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    return Column(
      children: [
        const SizedBox(height: 20.0),
        Text(
          '숲속 마을 친구들 탄신일',
          style: textTheme.bodyText1,
        ),
        Text(
          '${firstDay.year}.${firstDay.month}.${firstDay.day}',
          style: textTheme.bodyText2,
        ),
        const SizedBox(height: 16.0),
        IconButton(
          iconSize: 50.0,
          onPressed: onCakePressed,
          icon: Icon(
            Icons.cake,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 1.0),
        Text(
          'D+${DateTime(now.year, now.month, now.day).
          difference(firstDay).inDays + 1}',
          style: textTheme.headline2,
        ),
      ],
    );
  }
}

class _CharImage extends StatelessWidget {
  final VoidCallback onImageClicked1;
  final VoidCallback onImageClicked2;
  final VoidCallback onImageClicked3;


  _CharImage({
    required this.onImageClicked1,
    required this.onImageClicked2,
    required this.onImageClicked3,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width ~/ 2;
    final smallWidth = width / 2;
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 400.0, // 원하는 높이 설정
            ),
            Positioned(
              bottom: 0, // 아래로 이동 (높이 조정)
              left: 0, // 왼쪽으로 이동
              right: 0, // 오른쪽으로 이동
              child: makeRow('asset/img/crong.png', 'asset/img/petty.png',
                  'asset/img/pororo.png', rowWidth: width / 1.5.toDouble()),
            ),
          ],
        ),
      ],
    );
  }

  Widget makeRow(String leftPath, String centerPath, String rightPath,
      {double rowWidth = 12.0}) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: onImageClicked1, // 이미지 클릭 시 onImageClicked1 함수 호출
              child: Container(
                child: Image.asset(
                    leftPath, width: rowWidth - 10, height: rowWidth - 10),
                padding: EdgeInsets.all(5.0),
              ),
            ),
            GestureDetector(
              onTap: onImageClicked2, // 이미지 클릭 시 onImageClicked2 함수 호출
              child: Container(
                child: Image.asset(
                    centerPath, width: rowWidth - 10, height: rowWidth - 10),
                padding: EdgeInsets.all(5.0),
              ),
            ),
            GestureDetector(
              onTap: onImageClicked3, // 이미지 클릭 시 onImageClicked3 함수 호출
              child: Container(
                child: Image.asset(
                    rightPath, width: rowWidth - 10, height: rowWidth - 10),
                padding: EdgeInsets.all(5.0),
              ),
            ),
          ],
        ),
        Text(
          '아래화면 클릭 시 실행 됩니다',
          style: TextStyle(color: Colors.black,fontSize:30),
        ),
        Container(
          child: VideoPage(
              videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
          width: rowWidth + 280,
          height: rowWidth + 80,
        ),
      ],
    );
  }
}
