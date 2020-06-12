import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'SpeechRecognision.dart';
import 'package:flutter_speech/flutter_speech.dart';

const languages = const [const Language('Japanese', 'jp_JP'),];

class TestWidget extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<TestWidget> {
  SpeechRecognition speech;

  bool speechRecognitionAvailable = false;
  String inputtext = '';
  String inputtext2 = '';
  bool isListening = false;
  bool isMach = false;

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
    setState(() {});

    if (isListening) {
      inputtext2 = "音声認識真っ最中\n";
    } else {
      inputtext2 = "";
      start();
    }

    if (isMach) {
      return Scaffold(
          appBar: AppBar(title: Text("開発用ページ"),),

          floatingActionButton: FloatingActionButton(
            tooltip: 'Action!',
            child: Icon(Icons.mic),
            onPressed: () {},
            backgroundColor: Colors.red,
          ),

          body: Column(
              children: <Widget>[
                Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.grey)
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                  child: Text(
                    inputtext,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      height: 1.0,
                    ),
                    maxLines: 10,
                  ),
                ),
                Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.grey)
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                  child: Text(
                    inputtext2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      height: 1.0,
                    ),
                    maxLines: 10,
                  ),
                ),
              ]
          )
      );
    }
    //黒くなる
    else return Scaffold(

          appBar: AppBar(title: Text("開発用ページ"),),

          floatingActionButton: FloatingActionButton(
            tooltip: 'Action!',
            child: Icon(Icons.mic),
            onPressed: () {},
            backgroundColor: Colors.black,
          ),

          body: Column(
              children: <Widget>[
                Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.grey)
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                  child: Text(
                    inputtext,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      height: 1.0,
                    ),
                    maxLines: 10,
                  ),
                ),
                Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.grey)
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                  child: Text(
                    inputtext2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      height: 1.0,
                    ),
                    maxLines: 10,
                  ),
                ),
              ]
          )
      );
  }


  //SpeechRecognisionFunction
  void start() =>
      speech.activate(selectedLang.code).then((_) {
        return speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            isListening = result;
          });
        });
      });

  void cancel() =>
      speech.cancel().then((_) => setState(() => isListening = false));

  void stop() =>
      speech.stop().then((_) {
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
    setState(() => inputtext = text);
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();

}
