import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_speech/flutter_speech.dart';
import 'SpeechRecognition.dart' as mSpeech;

class TestWidget extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<TestWidget> {
  SpeechRecognition speech;
  mSpeech.Language selectedLang = mSpeech.languages.first;

  bool speechRecognitionAvailable = false;
  bool isMach = false;

  Color ButtonColor = Colors.red;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    print("into Widget build======================================");
    print("speech = $speech");
    setState(() {});
    print("exit setstate");
    globals.namedataG.contains(globals.inputText) ? isMach = true : isMach = false;
    isMach ? ButtonColor = Colors.red : ButtonColor = Colors.black;//isMachの値によってボタンの色を変える

    mSpeech.printInfo("isListening", globals.isListening);
    mSpeech.printInfo("speechRecognitionAvailable", speechRecognitionAvailable);

    print("連続音声認識が可能かどうかを見ています。==========");
    continueListen();
    print("音声認識が可能かどうかを見ました。=========");

    mSpeech.printInfo("isMach", isMach);
    if(isMach){
      isMach = false;
      globals.callFunc();
      globals.inputText = "";
      print("exit callFunc()");
    }

    //showSpeechInfo();

    return Scaffold(
        appBar: AppBar(title: Text("開発用ページ09/09"),),

        floatingActionButton: FloatingActionButton(
          tooltip: 'Action!',
          child: Icon(Icons.mic),
          onPressed: start,
          backgroundColor: ButtonColor,
        ),

        body: Column(
            children: <Widget>[
              Container(
                height: 100.0,
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

  //SpeechRecognitionFunction
  void activateSpeechRecognizer() {//activateっていうより更新処理っていうほうが適切かと
    print('_MyAppState.activateSpeechRecognizer... ');
    speech = new SpeechRecognition();//ここで新しくSpeechRecognition定義してるし、やっぱりerrorの後のはdestroy()でよかったっぽい？
    speech.setAvailabilityHandler(onSpeechAvailability);
    speech.setRecognitionStartedHandler(onRecognitionStarted);
    speech.setRecognitionResultHandler(onRecognitionResult);
    speech.setRecognitionCompleteHandler(onRecognitionComplete);
    speech.setErrorHandler(errorHandler);

    speech.activate(selectedLang.code).then((res) {
      mSpeech.printInfo("activate()", res);
      setState(() => speechRecognitionAvailable = res);
    });
    //onCurrentLocale(selectedLang.code);
    //showSpeechInfo();
  }

  //こいつ実行するとMethodChannel経由で音声認識スタートされる。
  void start(){
    print("start()====================");
    speech.activate(selectedLang.code).then((_) {
      return speech.listen().then((result) {
        //print('===================================== SPEECH RECOGNITION STARTED ==========================================');
        print('_MyAppState.start => result $result');
        setState(() {
          //print("on start()\n");
          globals.isListening = result;
          mSpeech.printInfo("now start(). isListening", result);
          print("start()end================");
        });
      });
    });
  }

  void cancel(){
    print("cancel()==================");
    speech.cancel().then((_) => setState(() {
      globals.isListening = false;
      print("cancel()end===================");
    }));
  }

  void stop() => speech.stop().then((_) {
    setState(() => globals.isListening = false);
  });

  //音声認識が利用可能かどうかを引っ張ってきてくれる
  void onSpeechAvailability(bool result) {
    print("on onSpeechAvailability()");
    setState(() => speechRecognitionAvailable = result);
  }

  //別言語が選択された時用だけど今回は言語は日本語だけだから特に用はない。
  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
            () => selectedLang = mSpeech.languages.firstWhere((l) => l.code == locale));
  }

  //音声認識開始
  void onRecognitionStarted() {
    print("on onRecognitionStarted()");
    setState(() => globals.isListening = true);
  }

  //途中経過
  void onRecognitionResult(String text) {
    print("on onRecognitionResult");
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => globals.inputText = text);
  }

  //音声認識正常終了
  void onRecognitionComplete(String text) {
    print("on onRecognitionComplete");
    print('_MyAppState.onRecognitionComplete... $text');
    //stop();
    setState(() => globals.isListening = false);
  }

  //エラー発生。聞き取れなかったり誰も何も言わなかったり。あとはBUSY状態で音声認識しようとするとダメっぽい。
  void errorHandler(){
    //cancel();
    activateSpeechRecognizer();
    //globals.isListening = false;
  }

  void continueListen(){
    if(speechRecognitionAvailable){
      globals.inputText2 = "Speech Recognition Available";
      if(globals.isListening){
        //available and listening
        print("現在音声認識を行っているため飛ばします。");
        globals.inputText2 += "\nisListening : true";
        globals.inputText2 += "\nDoing Recognition";
        //globals.isListening = false;
      }else{
        //available and not listening
        globals.inputText2 += "\nisListening : false";
        globals.inputText2 += "\nStart Recognition";
        print("連続音声認識を実行します。");
        //cancel();
        start();
      }
    }else{
      mSpeech.printInfo("SpeechRecognition NOT Available", speechRecognitionAvailable);
      if(globals.isListening){
        //unavailable and listening
        print("音声認識が実行不可能なのでisListeningをfalseにします。");
        globals.isListening = false;
      }
      //unavailable and not listening
      globals.inputText2 = "Speech Recognition NOT Available";
    }
  }

  void showSpeechInfo(){
    mSpeech.printInfo("AvailabilityHandler", onSpeechAvailability);
    mSpeech.printInfo("StartedHandler", onRecognitionStarted);
    mSpeech.printInfo("ResultHandler", onRecognitionResult);
    mSpeech.printInfo("CompleteHandler", onRecognitionComplete);
    mSpeech.printInfo("ErrorHandler", errorHandler);
  }

}
