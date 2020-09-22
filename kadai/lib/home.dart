//import 'dart:html';
import 'package:flutter/material.dart';
import 'routes/globals.dart' as globals;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'routes/edit_route.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audiofileplayer/audiofileplayer.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Audio audio;

void setname() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('namelist',globals.namedataG);
}

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

const languages = const [const Language('Japanese', 'ja'),];

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeWidget> {

  SpeechRecognition speech;

  bool speechRecognitionAvailable = false;
  bool isMach = false;
  bool isBLT = globals.bltflag;

  Language selectedLang = languages.first;

  void roadname() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.namedataG = prefs.getStringList('namelist') ?? [];
    this.setState(() {});
  }

  @override
  initState() {
    if(globals.firstflag){
      roadname();
      globals.firstflag = false;
    }
    super.initState();
    activateSpeechRecognizer();
    _notificationSetup();
  }

  void _notificationSetup(){
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    speech = new SpeechRecognition();
    speech.setAvailabilityHandler(onSpeechAvailability);
    speech.setRecognitionStartedHandler(onRecognitionStarted);
    speech.setRecognitionResultHandler(onRecognitionResult);
    speech.setRecognitionCompleteHandler(onRecognitionComplete);
    speech.setErrorHandler(errorHandler);
    speech.activate(selectedLang.code).then((res) {
      setState(() => speechRecognitionAvailable = res);
      print("exit from setState");
      //globals.isListening = false;
    });
    onCurrentLocale('ja_JA');
  }

  int _currentIndex = 1;

  final _pageWidgets = [
    NameWidget(),
    MusicWidget(),
    OptionWidget(),
  ];

  Widget build(BuildContext context) {

    setState((){});
    globals.namedataG.contains(globals.inputText) ? isMach = true : isMach = false;
    //isMach ? Bcolor = Colors.red : Bcolor = Colors.black;//isMachの値によってボタンの色を変える

    print("isListening:");
    print(globals.isListening);
    print("speechRecognitionAvailable:");
    print(speechRecognitionAvailable);

    if(speechRecognitionAvailable){
      globals.inputText2 = "Speech Recognition Available";
      if(globals.isListening){
        globals.isListening = false;
        globals.inputText2 += "\nisListening : false\n";
      }else{
        globals.inputText2 += "\nDoing Recognition";
        start();
      }
    }


    return Scaffold(
      body:_pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.border_color),
            title: Text('名前編集'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            title: Text('音楽再生'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('設定'),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
  //SpeechRecognisionFunction
  void start() =>
      speech.activate(selectedLang.code).then((_) {
        return speech.listen().then((result) {
          print('================== SPEECH RECOGNITION STARTED =================');
          print('_MyAppState.start => result $result');
          setState(() {
            print("on start()\n");
            globals.isListening = result;
          });
          print('=================== SPEECH RECOGNITION ENDED ==================');
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
    setState(() => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    print("on onRecognitionStarted()");
    setState(() => globals.isListening = true);
  }

  void onRecognitionResult(String text) {
    print("on onRecognitionResult");
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => globals.inputText = text);
    globals.isListening = false;
  }

  void onRecognitionComplete(String text) {
    print("on onRecognitionComplete");
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => globals.isListening = false);
  }

  void errorHandler() {
    activateSpeechRecognizer();
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index);
}

class NameWidget extends StatefulWidget {
  NameWidget({Key key}) : super(key: key);
  @override
  NameState createState() => NameState();
}

class NameState extends State<NameWidget> {

  List<String> namedata = globals.namedataG;

  void deleteName(int index){
    globals.namedataG.removeAt(index);
    setname();
    setState((){});
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(8.0),
            icon:Icon(Icons.mic),
            onPressed:()async{
              await Navigator.of(context).pushNamed('/test');
              this.setState(() {});
            },
          ),
          IconButton(
            padding: const EdgeInsets.all(8.0),
            icon:Icon(Icons.add),
            onPressed:()async{
              await Navigator.of(context).pushNamed('/add');
              this.setState(() {});
            },
          ),
        ],
        title: Text("名前編集"),
      ),
      
      floatingActionButton: FloatingActionButton(
        tooltip: 'Action!',
        child: Icon(Icons.tap_and_play),
        onPressed: () {
          globals.callFunc();
          setState(() {});
        }
      ),
      
      body: ListView.separated(
        itemCount: namedata.length,
        separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black,),
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.20,
            child:ListTile(
              title: Text(namedata[index]),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                color: Colors.black45,
                iconWidget: Text(
                  "編集",
                  style: TextStyle(color: Colors.white),
                ),
                onTap:()async{
                  await Navigator.push(context,new MaterialPageRoute(
                      builder: (context){return Edit(index: index);}
                    )
                  );
                  setState(() {});
                },
              ),
              IconSlideAction(
                color: Colors.red,
                iconWidget: Text(
                  "削除",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {deleteName(index);}
              ),
            ]
          );
        }
      )
      
    );
  }
}

class MusicWidget extends StatefulWidget {
  @override
  MusicState createState() => MusicState();
}

class MusicState extends State<MusicWidget> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("音楽再生"),),

      body: Container(
        margin: EdgeInsets.only(top:50.0,left:10.0,right:10.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
                child: Text("天ノ弱"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {});
                  if(globals.firstMusicflag)globals.firstMusicflag = false;
                  else{
                    audio.pause();
                    audio.dispose();
                  }
                  audio = Audio.load('assets/audios/AMANOZYAKU.mp3', playInBackground: true);
                  audio.play();
                },
              ),
              RaisedButton(
                child: Text("車輪の唄"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {});
                  if(globals.firstMusicflag)globals.firstMusicflag = false;
                  else{
                    audio.pause();
                    audio.dispose();
                  }
                  audio = Audio.load('assets/audios/syarin.m4a', playInBackground: true);
                  audio.play();
                },
              ),
              RaisedButton(
                child: Text("再生停止"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {});
                  audio.pause();
                  //_audio.dispose();
                },
              ),
              RaisedButton(
                child: Text("再生再開"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {});
                  audio.resume();
                },
              ),
          ]
        )
      )
    );
  }
}

class OptionWidget extends StatefulWidget {
  @override
  OptionState createState() => OptionState();
}

class OptionState extends State<OptionWidget> {

    bool _backValue = globals.backflag;
    bool _musicValue = globals.musicflag;
    bool _bltValue = globals.bltflag;
    bool _notificationValue = globals.notificationflag;

    

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("設定"),),

      body: Container(
        margin: EdgeInsets.only(top:50.0,left:10.0,right:10.0),
        child: Column(
          children: <Widget>[
            SwitchListTile(
            value: _backValue,
            onChanged: (bool value) {
              setState(() {
                _backValue = value;
                globals.backflag = _backValue;
              });
              },
            title: Text("バックグラウンドでの動作"),
            ),
            SwitchListTile(
            value: _musicValue,
            onChanged: (bool value) {
              setState(() {
                _musicValue = value;
                globals.musicflag = _musicValue;
              });
            },
            title: Text("音楽再生を停止する"),
            ),
            SwitchListTile(
            value: _bltValue,
            onChanged: (bool value) {
              setState(() {
                //_bltValue = value;
                //globals.bltflag = _bltValue;
                //if(_bltValue) globals.onBluetoothStart();
                //else globals.onBluetoothStop();
              });
            },
            title: Text("BlueTooth機器(ESP)と接続する"),
            ),
            SwitchListTile(
            value: _notificationValue,
            onChanged: (bool value) {
              setState(() {
                _notificationValue = value;
                globals.notificationflag = _notificationValue;
              });
            },
            title: Text("通知をONにする"),
            ),
          ]
        )
      )
    );
  }
}
