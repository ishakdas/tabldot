import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<VideoApp> {
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.url);
    await Future.wait([_videoPlayerController1.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: false,
      allowFullScreen: false,
      looping: true,
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },
    );
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController!,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
