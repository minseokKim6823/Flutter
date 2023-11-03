import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;

  VideoPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  late Future<void> _initailizedController;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initailizedController = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100.0), // 위쪽 여백을 조절하세요
      child: FutureBuilder(
        future: _initailizedController,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: 16 / 9, // 비디오의 가로세로 비율을 조정할 수 있습니다.
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return CircularProgressIndicator(); // 또는 다른 로딩 표시 위젯
          }
        },
      ),
    );
  }
}