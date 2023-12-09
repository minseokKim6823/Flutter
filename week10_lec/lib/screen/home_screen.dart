import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week10_lec/component/main_calendar.dart';
import 'package:week10_lec/component/schedule_card.dart';
import 'package:week10_lec/component/today_banner.dart';
import 'package:week10_lec/component/schedule_bottom_sheet.dart';
import 'package:week10_lec/const/colors.dart';
import 'package:week10_lec/model/schedule_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week10_lec/screen/login_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모각코'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
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
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            SizedBox(height: 8.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedule',)
                  .where(
                'date',
                isEqualTo:
                '${selectedDate.year}${selectedDate.month}${selectedDate.day}',
              )
                  .snapshots(),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.docs.length ?? 0,
                );
              },
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('schedule',)
                    .where(
                  'date',
                  isEqualTo:
                  '${selectedDate.year}${selectedDate.month}${selectedDate.day}',
                )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('일정 정보를 가져오지 못했습니다.'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  final schedules = snapshot.data!.docs
                      .map(
                        (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
                        json: (e.data() as Map<String, dynamic>)),
                  )
                      .toList();

                  return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];

                      return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          FirebaseFirestore.instance
                              .collection('schedule')
                              .doc(schedule.id)
                              .delete();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: ScheduleCard(
                            startTime: schedule.startTime,
                            endTime: schedule.endTime,
                            content: schedule.content,
                            member: schedule.member,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }

  void onDaySelected(
      DateTime selectedDate,
      DateTime focusedDate,
      BuildContext context,
      ) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // 홈, 캘린더, 설정 인덱스에 따라 화면 전환
    if (index == 0) {
      // '홈' 탭을 눌렀을 때 처리
    } else if (index == 1) {
      // '캘린더' 탭을 눌렀을 때 처리
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CalendarScreen(),
        ),
      );
    } else if (index == 2) {
      // '설정' 탭을 눌렀을 때 처리
    }
  }
}

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('캘린더'),
      ),
      body: Center(
        child: Text('캘린더 화면입니다!'),
      ),
    );
  }
}