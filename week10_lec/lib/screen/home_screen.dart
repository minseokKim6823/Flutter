import 'package:flutter/material.dart';
import 'package:week10_lec/component/main_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) :super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  DateTime selectedDate = DateTime.utc( // ➋ 선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
            ),
          ],
        ),
      )
    );
  }
  void onDaySelected(DateTime selectedDate, DateTime focusedDate){// ➌ 날짜 선택될 때마다 실행할 함수
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}