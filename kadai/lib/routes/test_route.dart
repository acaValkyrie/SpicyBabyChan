import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_speech/flutter_speech.dart';

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

const languages = const [const Language('Japanese', 'jp_JP'),];

class TestWidget extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<TestWidget> {
  SpeechRecognition speech;

  bool speechRecognitionAvailable = false;
  bool isMach = false;
  bool isListening = false;

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

    if(!isListening && speechRecognitionAvailable){
      globals.inputText2 = "";
      start();
    }
    if(isListening){
      globals.inputText2 = "isListening : true\n";
    }

    if (isListening) {
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
    setState(() => globals.inputText = text);
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();

}
