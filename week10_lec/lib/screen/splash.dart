
import 'package:flutter/material.dart';
import 'package:week10_lec/screen/login_screen.dart';
import 'package:week10_lec/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // 로딩 중이면 로딩 표시
        }

        final user = snapshot.data;

        if (user == null) {
          // 로그인되지 않은 상태라면 로그인 화면 표시
          return Login();
        } else {
          // 로그인된 상태라면 홈 화면 표시
          Future.delayed(Duration.zero, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          });
          return Container(); // 필요에 따라 임시로 빈 컨테이너를 반환
        }
      },
    );
  }
}