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
  late Future<void> _initializedController;

  @override
  void initState() {
  _controller = VideoPlayerController.network(widget.videoUrl);
  _initializedController = _controller.initialize();
  super.initState();
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: _initializedController,
    builder: (context, snapshot) {
      return AspectRatio(
        aspectRatio: 16 / 9,
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
      },
    );
  }
}
