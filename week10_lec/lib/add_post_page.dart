import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 등록'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: '비밀번호'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Check if password is valid (for example, at least 6 characters)
                  if (_passwordController.text.length >= 6) {
                    // Save post data to Firestore with password
                    FirebaseFirestore.instance.collection('posts').add({
                      'title': _titleController.text,
                      'body': _bodyController.text,
                      'password': _passwordController.text,
                    });

                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  } else {
                    // Show an error message or alert for an invalid password
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('비밀번호는 최소 6자 이상이어야 합니다.'),
                      ),
                    );
                  }
                },
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
