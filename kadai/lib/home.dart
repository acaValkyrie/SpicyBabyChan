import 'package:flutter/material.dart';
import 'routes/globals.dart' as globals;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'routes/edit_route.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({Key key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeWidget> {

  int _currentIndex = 0;

  final _pageWidgets = [
    NameWidget(),
    OptionWidget(),
  ];

  Widget build(BuildContext context) {

    setState((){});

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
            icon: Icon(Icons.settings),
            title: Text('設定'),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index);
}

class NameWidget extends StatefulWidget {
  NameWidget({Key key}) : super(key: key);
  @override
  NameState createState() => NameState();
}

class NameState extends State<NameWidget> {

  List<bool> _flag = globals.flagG;
  List<String> namedata = globals.namedataG;

  void deleteName(int index){
    globals.namedataG.removeAt(index);
    globals.flagG.removeAt(index);
    setState((){});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(8.0),
            icon:Icon(Icons.music_note),
            onPressed:()async{
              await Navigator.of(context).pushNamed('/test2');
              this.setState(() {});
            },
          ),
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
            child:CheckboxListTile(
              value: _flag[index],
              onChanged: (bool e) {
                setState(() => _flag[index] = e);
              },
              title: Text(namedata[index]),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.blue,
              selected: _flag[index],
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
      ),
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
