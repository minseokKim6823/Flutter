// import 'package:week10_lec/model/schedule_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:week10_lec/component/main_calendar.dart';
// import 'package:week10_lec/component/schedule_card.dart';
// import 'package:week10_lec/component/today_banner.dart';
// import 'package:week10_lec/component/schedule_bottom_sheet.dart';
// import 'package:week10_lec/const/colors.dart';
// import 'package:week10_lec/screen/login_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   PageController _pageController = PageController();
//   int _currentIndex = 0;
//
//   DateTime selectedDate = DateTime.utc(
//     DateTime.now().year,
//     DateTime.now().month,
//     DateTime.now().day,
//   );
//   // void onDaySelected(
//   //     DateTime selectedDate,
//   //     DateTime focusedDate,
//   //     BuildContext context,
//   //     ) {
//   //   setState(() {
//   //     this.selectedDate = selectedDate;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('모각코'),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => Login()),
//               );
//             },
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
//         backgroundColor: PRIMARY_COLOR,
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             isDismissible: true,
//             isScrollControlled: true,
//             builder: (_) => ScheduleBottomSheet(
//               selectedDate: selectedDate,
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ) : null,
//       body: SafeArea(
//         child: PageView(
//           controller: _pageController,
//           onPageChanged: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           children: [
//             HomeContent(selectedDate: selectedDate, onDaySelected: onDaySelected),
//             OtherScreen(),
//             TheOtherScreen(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//             _pageController.animateToPage(
//               index,
//               duration: Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//             );
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: '모각코 계획',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.developer_board),
//             label: '게시판',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: '채팅',
//           ),
//
//         ],
//       ),
//     );
//   }
// }
//
// class HomeContent extends StatefulWidget {
//   final DateTime selectedDate;
//   final Function(DateTime, DateTime, BuildContext) onDaySelected;
//
//   HomeContent({
//     required this.selectedDate,
//     required this.onDaySelected,
//   });
//
//   @override
//   _HomeContentState createState() => _HomeContentState();
// }
//
// class _HomeContentState extends State<HomeContent> {
//   DateTime selectedDate = DateTime.now();
//
//   void onDaySelected(
//       DateTime selectedDate,
//       DateTime focusedDate,
//       BuildContext context,
//       ) {
//     setState(() {
//       this.selectedDate = selectedDate;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       // 시스템 UI 피해서 UI 구현하기
//       child: Column(
//         // 달력과 리스트를 세로로 배치
//         children: [
//           MainCalendar(
//             selectedDate: selectedDate, // 선택된 날짜 전달하기
//
//             // 날짜가 선택됐을 때 실행할 함수
//             onDaySelected: (selectedDate, focusedDate) =>
//                 onDaySelected(selectedDate, focusedDate, context),
//           ),
//           SizedBox(height: 8.0),
//           StreamBuilder<QuerySnapshot>(
//             // ListView에 적용했던 같은 쿼리
//             stream: FirebaseFirestore.instance
//                 .collection('schedule',)
//                 .where(
//               'date',
//               isEqualTo:
//               '${selectedDate.year}${selectedDate.month}${selectedDate.day}',
//             )
//                 .snapshots(),
//             builder: (context, snapshot) {
//               return TodayBanner(
//                 selectedDate: selectedDate,
//                 // ➊ 개수 가져오기
//                 count: snapshot.data?.docs.length ?? 0,
//               );
//             },
//           ),
//           SizedBox(height: 8.0),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               // ➊ 파이어스토어로부터 일정 정보 받아오기
//               stream: FirebaseFirestore.instance
//                   .collection('schedule',)
//                   .where(
//                 'date',
//                 isEqualTo:
//                 '${selectedDate.year}${selectedDate.month}${selectedDate.day}',
//               )
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 // Stream을 가져오는 동안 에러가 났을 때 보여줄 화면
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('일정 정보를 가져오지 못했습니다.'),
//                   );
//                 }
//
//                 // 로딩 중일 때 보여줄 화면
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Container();
//                 }
//
//                 // ➋ ScheduleModel로 데이터 매핑하기
//                 final schedules = snapshot.data!.docs
//                     .map(
//                       (QueryDocumentSnapshot e) => ScheduleModel.fromJson(
//                       json: (e.data() as Map<String, dynamic>)),
//                 )
//                     .toList();
//
//                 return ListView.builder(
//                   itemCount: schedules.length,
//                   itemBuilder: (context, index) {
//                     final schedule = schedules[index];
//
//                     return Dismissible(
//                       key: ObjectKey(schedule.id),
//                       direction: DismissDirection.startToEnd,
//                       onDismissed: (DismissDirection direction) {
//                         FirebaseFirestore.instance
//                             .collection('schedule')
//                             .doc(schedule.id)
//                             .delete();
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             bottom: 8.0, left: 8.0, right: 8.0),
//                         child: ScheduleCard(
//                           startTime: schedule.startTime,
//                           endTime: schedule.endTime,
//                           content: schedule.content,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//     child: Center(
//       child: Text('Home Content'),
//     );
//   }
// }
//
// class OtherScreen extends StatefulWidget {
//   @override
//   _OtherScreenState createState() => _OtherScreenState();
// }
//
// class _OtherScreenState extends State<OtherScreen> {
//   TextEditingController postController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: firestore.collection('posts').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('데이터를 불러오지 못했습니다.'),
//                   );
//                 }
//
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//
//                 List<DocumentSnapshot> posts = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   itemCount: posts.length,
//                   itemBuilder: (context, index) {
//                     String postId = posts[index].id;
//                     String postContent = posts[index]['content'];
//
//                     return ListTile(
//                       title: Text(postContent),
//                       onTap: () {
//                         navigateToPostDetail(context, postId);
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: postController,
//                   decoration: InputDecoration(
//                     hintText: '게시물 내용 입력',
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     hintText: '비밀번호 입력',
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     addPost(passwordController.text);
//                   },
//                   child: Text('추가'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void navigateToPostDetail(BuildContext context, String postId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PostDetailScreen(postId: postId),
//       ),
//     );
//   }
//
//   void addPost(String password) async {
//     if (postController.text.isNotEmpty && password.isNotEmpty) {
//       await firestore.collection('posts').add({
//         'content': postController.text,
//         'password': password,
//       });
//
//       postController.clear();
//     }
//   }
// }
//
// class PostDetailScreen extends StatefulWidget {
//   final String postId;
//
//   const PostDetailScreen({Key? key, required this.postId}) : super(key: key);
//
//   @override
//   _PostDetailScreenState createState() => _PostDetailScreenState();
// }
//
// class _PostDetailScreenState extends State<PostDetailScreen> {
//   TextEditingController detailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   String password = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('게시물 상세 정보'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               updatePostDialog();
//             },
//             icon: Icon(Icons.edit),
//           ),
//           IconButton(
//             onPressed: () {
//               deletePostDialog();
//             },
//             icon: Icon(Icons.delete),
//           ),
//         ],
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: firestore.collection('posts').doc(widget.postId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('데이터를 불러오지 못했습니다.'),
//             );
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           String postContent = snapshot.data!['content'];
//
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '게시물 내용:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(postContent),
//                 SizedBox(height: 16.0),
//                 Text(
//                   '상세 내용 편집:',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 TextField(
//                   controller: detailController,
//                   decoration: InputDecoration(
//                     hintText: '상세 내용 입력',
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void updatePostDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('게시물 수정'),
//           content: Column(
//             children: [
//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: '비밀번호',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('취소'),
//             ),
//             TextButton(
//               onPressed: () {
//                 updatePost(passwordController.text);
//                 Navigator.pop(context);
//               },
//               child: Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void deletePostDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('게시물 삭제'),
//           content: Column(
//             children: [
//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: '비밀번호',
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('취소'),
//             ),
//             TextButton(
//               onPressed: () {
//                 deletePost(passwordController.text);
//                 Navigator.pop(context);
//               },
//               child: Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void updatePost(String newPassword) async {
//     if (newPassword == password) {
//       await firestore.collection('posts').doc(widget.postId).update({
//         'content': detailController.text,
//         'password': newPassword,
//       });
//
//       Navigator.pop(context); // 상세 화면으로부터 뒤로 이동
//     } else {
//       showPasswordMismatchDialog();
//     }
//   }
//
//   void deletePost(String enteredPassword) async {
//     if (enteredPassword == password) {
//       await firestore.collection('posts').doc(widget.postId).delete();
//
//       Navigator.pop(context); // 상세 화면으로부터 뒤로 이동
//     } else {
//       showPasswordMismatchDialog();
//     }
//   }
//   void showPasswordMismatchDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('비밀번호 오류'),
//           content: Text('비밀번호가 다릅니다.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('확인'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// class TheOtherScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // 다른 화면의 내용 구현
//       // ...
//       child: Center(
//         child: Text('The Other Screen'),
//       ),
//     );
//   }
// }

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
