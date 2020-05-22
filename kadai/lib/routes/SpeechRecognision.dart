import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';

String txtupdate(String str){
  str = "aiueo,\n日本語表示と改行";
  return str;
}

bool islsn(bool lisn){
  lisn = true;
  return lisn;
}

class SpeechRecognision extends StatefulWidget{
  @override
  SpRcgState createState() => SpRcgState();
}

class SpRcgState extends State<SpeechRecognision> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
