import 'package:flutter/material.dart';
import 'package:test_video/video_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);


  List<String> urls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 2,
          itemBuilder: (_, index) {
            return VideoPage(videoUrl: urls[index]);
          }),
    );
  }
}