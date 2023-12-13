import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week10_lec/add_post_page.dart';
import 'package:week10_lec/screen/home_screen.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
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
        title: Text('수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _bodyController,
              maxLines: 4,
              decoration: InputDecoration(labelText: '내용'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
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
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}