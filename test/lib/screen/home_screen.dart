import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
        backgroundColor: Colors.pink[100],
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DDay(
                //하트 눌렀을때 실행할 함수 전달하기
                onHeartPressed: onHeartPressed,
                firstDay: firstDay,
              ),
              _GersImage(),
            ],
          ),
        ));
  }

  void onHeartPressed() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 350,
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
}

class _DDay extends StatelessWidget{
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  _DDay({
    required this.onHeartPressed,
    required this.firstDay,
  });
  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    final now =DateTime.now();
    return Column(
      children: [
        const SizedBox(height:20.0),
        Text(
          '우리 처음 만난 날',
          style:  textTheme.bodyText1,
        ),
        Text(
          '${firstDay.year}.${firstDay.month}.${firstDay.day}',
          style: textTheme.bodyText2,
        ),
        const SizedBox(height: 16.0),
        IconButton(
          iconSize:50.0,
          onPressed: onHeartPressed,
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 1.0),
        Text(
          'D+${DateTime(now.year,now.month,now.day).difference(firstDay).inDays+1}',

          style: textTheme.headline2,
        ),
      ],
    );
  }
}
class _GersImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width ~/ 2;
    final smallWidth = width / 2;
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 450.0, // 원하는 높이 설정
              color: Colors.pink[100], // 배경색 설정
            ),
            Positioned(
              bottom: 310, // 아래로 이동 (높이 조정)
              left: 0, // 왼쪽으로 이동
              right: 0, // 오른쪽으로 이동
              child: makeRow('asset/img/crong.png', 'asset/img/petty.png', 'asset/img/pororo.png', rowWidth: width / 1.5.toDouble()),
            ),
          ],
        ),
      ],
    );
  }

  Widget makeRow(String leftPath, String centerPath, String rightPath, {double rowWidth = 12.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 이미지 중앙 정렬
      children: <Widget>[
        Container(
          child: Image.asset(leftPath, width: rowWidth - 10, height: rowWidth - 10),
          padding: EdgeInsets.all(5.0),
        ),
        Container(
          child: Image.asset(centerPath, width: rowWidth - 10, height: rowWidth - 10),
          padding: EdgeInsets.all(5.0),
        ),
        Container(
          child: Image.asset(rightPath, width: rowWidth - 10, height: rowWidth - 10),
          padding: EdgeInsets.all(5.0),
        ),
      ],
    );
  }
}