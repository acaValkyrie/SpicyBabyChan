import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:io';
import 'package:vibration/vibration.dart';

class Test2Widget extends StatefulWidget {
  @override
  Test2State createState() => Test2State();
}

class Test2State extends State<Test2Widget> {

  bool isAndroid = Platform.isAndroid;

  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  final audio = Audio("assets/audios/_7thsence.mp3");
  
  
  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer.stop();
  }
 
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Audio Player Demo'),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Action!',
          child: Icon(Icons.stop), 
          onPressed: () async{
            _assetsAudioPlayer.open(
              audio,
              showNotification: true,
            );
            Vibration.vibrate(duration: 500 ,amplitude: 128);
            setState(() {});
          }
        ),
      );
  }
}
