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
import 'package:week10_lec/add_post_page.dart';

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
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
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
          builder: (context) => BoardScreen(),
        ),
      );
    } else if (index == 2) {
      // '설정' 탭을 눌렀을 때 처리
    }
  }
}

class BoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '게시판 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '게시판'),
    );
  }
}
class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('데이터를 가져올 수 없습니다.'));
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final data = documents[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['title'] ?? ''),
                subtitle: Text(data['body'] ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // 글 수정 기능 추가
                        _editPost(context, documents[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // 글 삭제 기능 추가
                        _deletePost(context, documents[index]);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 글 수정 함수
  void _editPost(BuildContext context, DocumentSnapshot document) {
    TextEditingController _passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비밀번호 확인'),
          content: Column(
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // 비밀번호 검증
                  if (_passwordController.text == document['password']) {
                    // 비밀번호가 일치하면 수정 페이지로 이동
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPostPage(document: document),
                      ),
                    );
                  } else {
                    // 비밀번호가 일치하지 않을 때 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('비밀번호가 일치하지 않습니다.'),
                      ),
                    );
                  }
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      },
    );
  }

  // 글 삭제 함수
  void _deletePost(BuildContext context, DocumentSnapshot document) {
    // 비밀번호 입력 다이얼로그 띄우기
    TextEditingController _passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비밀번호 확인'),
          content: Column(
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // 비밀번호 검증
                  if (_passwordController.text == document['password']) {
                    // 비밀번호가 일치하면 삭제 수행
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(document.id)
                        .delete();
                    Navigator.pop(context);
                  } else {
                    // 비밀번호가 일치하지 않을 때 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('비밀번호가 일치하지 않습니다.'),
                      ),
                    );
                  }
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      },
    );
  }
}
class EditPostPage extends StatefulWidget {
  final DocumentSnapshot document;

  EditPostPage({required this.document});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.document['title'] ?? '';
    _bodyController.text = widget.document['body'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _bodyController,
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save edited data to Firestore
                FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.document.id)
                    .update({
                  'title': _titleController.text,
                  'body': _bodyController.text,
                });

                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}