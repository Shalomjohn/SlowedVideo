import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({Key? key, required this.videoPath}) : super(key: key);
  final String? videoPath;

  @override
  VideoViewState createState() => VideoViewState();
}

class VideoViewState extends State<VideoView> {
  late VideoPlayerController _controller;
  bool isSlowed = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPath == null
        ? VideoPlayerController.asset('assets/test_video.mp4')
        : VideoPlayerController.file(File(widget.videoPath!))
      ..initialize().then((_) {
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        InkWell(
          onTap: () {
            setState(() {
              isSlowed
                  ? _controller.setPlaybackSpeed(1)
                  : _controller.setPlaybackSpeed(0.5);
              isSlowed = isSlowed ? false : true;
            });
          },
          child: Image.asset("assets/snail_icon.png"),
        )
      ]),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
