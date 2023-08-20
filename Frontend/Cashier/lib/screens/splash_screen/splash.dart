import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../routes/routes.dart';
import '../../utilities/c_colors.dart';
import '../../utilities/c_video.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller=VideoPlayerController.asset(Cvideo.splashV)
    ..initialize().then((_){
      setState(() {});
      
    });
    _playVideo();
  }
  void _playVideo()async{
    _controller.play();
    await Future.delayed(const Duration(seconds: (5)
    ));
    Navigator.pop(context);
    Get.offAllNamed(Croutes.onboarding);
  }
  @override
  void dispose() {
   _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: CColors.Black,
     body: Center(
      child: _controller.value.isInitialized
      ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(
          _controller
        ),
      )
      :Container(),
      ),
    );
  }
}