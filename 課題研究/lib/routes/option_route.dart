import 'package:flutter/material.dart';
import 'globals.dart' as globals;
 

class Option extends StatefulWidget {
  @override
  OptionState createState() => OptionState();
}


class OptionState extends State<Option> { // <- (※1)

    bool _backValue = globals.backflag;
    bool _musicValue = globals.musicflag;
    bool _moveValue = globals.moveflag;
    

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
            title: Text("音楽再生を停止"),
            ),
            SwitchListTile(
            value: _moveValue,
            onChanged: (bool value) {
              setState(() { 
                _moveValue = value;
                globals.moveflag = _moveValue;
              });
            },
            title: Text("バイブレーションを動作"),
            ),
          ]
        )
      )
      
    );
  }
}