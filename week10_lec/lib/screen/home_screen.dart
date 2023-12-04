import 'package:week10_lec/model/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:week10_lec/component/main_calendar.dart';
import 'package:week10_lec/component/schedule_card.dart';
import 'package:week10_lec/component/today_banner.dart';
import 'package:week10_lec/component/schedule_bottom_sheet.dart';
import 'package:week10_lec/const/colors.dart';
import 'package:week10_lec/screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  void onDaySelected(
      DateTime selectedDate,
      DateTime focusedDate,
      BuildContext context,
      ) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모각코 모집'),
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
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
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
        child: Icon(Icons.add),
      ) : null,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            HomeContent(selectedDate: selectedDate, onDaySelected: onDaySelected),
            OtherScreen(),
            TheOtherScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '모각코 계획',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.developer_board),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅',
          ),

        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime, DateTime, BuildContext) onDaySelected;

  HomeContent({
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  DateTime selectedDate = DateTime.now();

  void onDaySelected(
      DateTime selectedDate,
      DateTime focusedDate,
      BuildContext context,
      ) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        // 시스템 UI 피해서 UI 구현하기
        child: Column(
          // 달력과 리스트를 세로로 배치
          children: [
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달하기

              // 날짜가 선택됐을 때 실행할 함수
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            SizedBox(height: 8.0),
            StreamBuilder<QuerySnapshot>(
              // ListView에 적용했던 같은 쿼리
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
                  // ➊ 개수 가져오기
                  count: snapshot.data?.docs.length ?? 0,
                );
              },
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // ➊ 파이어스토어로부터 일정 정보 받아오기
                stream: FirebaseFirestore.instance
                    .collection('schedule',)
                    .where(
                  'date',
                  isEqualTo:
                  '${selectedDate.year}${selectedDate.month}${selectedDate.day}',
                )
                    .snapshots(),
                builder: (context, snapshot) {
                  // Stream을 가져오는 동안 에러가 났을 때 보여줄 화면
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('일정 정보를 가져오지 못했습니다.'),
                    );
                  }

                  // 로딩 중일 때 보여줄 화면
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  // ➋ ScheduleModel로 데이터 매핑하기
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
      );
      child: Center(
        child: Text('Home Content'),
      );
  }
}
class OtherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 다른 화면의 내용 구현
      // ...
      child: Center(
        child: Text('Other Screen'),
      ),
    );
  }
}class TheOtherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 다른 화면의 내용 구현
      // ...
      child: Center(
        child: Text('The Other Screen'),
      ),
    );
  }
}
