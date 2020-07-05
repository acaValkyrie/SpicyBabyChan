import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_speech/flutter_speech.dart';

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

const languages = const [const Language('English', 'en_EN'),];

class TestWidget extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<TestWidget> {
  SpeechRecognition speech;

  bool speechRecognitionAvailable = false;
  bool isMach = false;
  //bool isListening = false;

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
    speech.activate('en_EN').then((res) {
      print("on activateSpeechRecognizer. res = ");
      print(res);
      setState(() => speechRecognitionAvailable = res);
      print("exit from setState");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("into Widget build");
    setState(() {});
    print("exit setstate");
    globals.namedataG.contains(globals.inputText) ? isMach = true : isMach = false;

    print("isListening:");
    print(globals.isListening);
    print("speechRecognitionAvailable:");
    print(speechRecognitionAvailable);

    if(speechRecognitionAvailable){
      if(globals.isListening){
        globals.isListening = false;
      }else{
        globals.inputText2 = "";
        start();
      }
    }
    /*
    if(!globals.isListening){
      print("Let's start()");
      globals.inputText2 = "";
      start();
    }
    if(globals.isListening){
      print("isListening = true");
      print("avalable:");
      print(speechRecognitionAvailable);
      globals.inputText2 = "isListening : true\n";
    }else{
      print("isListening = false");
      globals.inputText2 = "isListening : false\n";
    }*/

    if(isMach){
      //globals.callFunc();
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
                    globals.inputText,
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
                    globals.inputText2,
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
                    globals.inputText,
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
                    globals.inputText2,
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

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages.map((l) => new CheckedPopupMenuItem<Language>(
    value: l,
    checked: selectedLang == l,
    child: new Text(l.name),
  ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  //SpeechRecognisionFunction
  void start() =>
      speech.activate(selectedLang.code).then((_) {
        return speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            print("on start()\n");
            globals.isListening = result;
          });
        });
      });

  void cancel() =>
      speech.cancel().then((_) => setState((){
        print("on cancel()");
        globals.isListening = false;
      }));


  void stop() =>
      speech.stop().then((_) {
        print("on stop()");
        setState(() => globals.isListening = false);
      });

  void onSpeechAvailability(bool result) {
    print("on onSpeechAvailability()");
    setState(() => speechRecognitionAvailable = result);
  }

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
            () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    print("on onRecognitionStarted()");
    setState(() => globals.isListening = true);
  }

  void onRecognitionResult(String text) {
    print("on onRecognitionResult");
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => globals.inputText = text);
  }

  void onRecognitionComplete(String text) {
    print("on onRecognitionComplete");
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => globals.isListening = false);
  }

  void errorHandler(){
    print("on errorHandler");
    activateSpeechRecognizer();
  }

}
