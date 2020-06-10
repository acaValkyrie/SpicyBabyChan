import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'SpeechRecognision.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:flutter/foundation.dart';

class Test extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {

  SpeechRecognition speech;

  bool speechRecognitionAvailable = false;
  bool isListening = false;
  bool isMatch = false;

  String transcription = '';
  String represent = '';
  String text = '';

  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    speech = new SpeechRecognition();
    speech.setAvailabilityHandler(onSpeechAvailability);
    speech.setRecognitionStartedHandler(onRecognitionStarted);
    speech.setRecognitionResultHandler(onRecognitionResult);
    speech.setRecognitionCompleteHandler(onRecognitionComplete);
    speech.setErrorHandler(errorHandler);
    speech.activate('jp_JP').then((res) {
      setState(() => speechRecognitionAvailable = res);
    });
  }



  @override
  Widget build(BuildContext context) {

    setState((){});
    text = transcription + represent;
/*
    String inputtext;
    bool isListening;
    inputtext = txtupdate(inputtext);
    isListening = islsn(isListening);
*/

    //連続音声認識用
    if(!isListening) {
      represent = '\n音声認識してないです';
      start();
      represent = '\n音声認識中です';
    }

    isMatch = globals.namedataG.contains(transcription);

    //赤くなる
    if (isMatch) {
      return Scaffold(
        appBar:AppBar(title: Text("開発用ページ"),),

        floatingActionButton: FloatingActionButton(
          tooltip: 'Action!',
          child: Icon(Icons.mic), 
          onPressed: (){},
          backgroundColor: Colors.red,
        ),

        body: Container(
          height: 400.0,
          width: double.infinity,
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey) 
          ),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top:50.0,left:20.0,right:20.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              height: 1.0,
            ),
            maxLines:10,
          ),
        ),
      );
    }
    //黒くなる
    else return Scaffold(

      appBar:AppBar(title: Text("開発用ページ"),),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Action!',
        child: Icon(Icons.mic), 
        onPressed: (){},
        backgroundColor: Colors.black,
      ),

      body: Container(
        height: 400.0,
        width: double.infinity,
         decoration: new BoxDecoration(
          border: new Border.all(color: Colors.grey) 
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(top:50.0,left:20.0,right:20.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            height: 1.0,
          ),
          maxLines:10,
        ),
      ),
    );
  }

  //SpeechRecognisionFunction
  void start() => speech.activate(selectedLang.code).then((_) {
    return speech.listen().then((result) {
      print('_MyAppState.start => result $result');
      setState(() {
        isListening = result;
      });
    });
  });

  void cancel() =>
      speech.cancel().then((_) => setState(() => isListening = false));

  void stop() => speech.stop().then((_) {
    setState(() => isListening = false);
  });

  void onSpeechAvailability(bool result) =>
      setState(() => speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
            () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => transcription = text);
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();
}
