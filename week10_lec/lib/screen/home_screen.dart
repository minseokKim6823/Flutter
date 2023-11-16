import 'package:flutter/material.dart';
import 'package:week10_lec/component/main_calendar.dart';
import 'package:week10_lec/component/schedule_card.dart';
import 'package:week10_lec/component/today_banner.dart';
import 'package:week10_lec/component/schedule_bottom_sheet.dart';
import 'package:week10_lec/const/colors.dart';


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
        floatingActionButton: FloatingActionButton( // ➊ 새 일정 버튼
          backgroundColor: PRIMARY_COLOR,
          onPressed: () {
            showModalBottomSheet( // ➋ BottomSheet 열기
              context: context,
              isDismissible: true, // ➌ 배경 탭했을 때 BottomSheet 닫기
              builder: (_) => ScheduleBottomSheet(),
            );
          },
          child: Icon(
            Icons.add,
          ),
        ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0),
            TodayBanner(
                selectedDate: selectedDate,
                count: 0,
            ),
            SizedBox(height: 8.0),
            ScheduleCard(startTime: 12, endTime: 14, content: '스모프 학습'),
          ]
        )
      )
    );
  }
  void onDaySelected(DateTime selectedDate, DateTime focusedDate){// ➌ 날짜 선택될 때마다 실행할 함수
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}