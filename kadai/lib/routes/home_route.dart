import 'package:flutter/material.dart';
import 'add_route.dart';
import 'test_route.dart';
import 'globals.dart' as globals;
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  
  void deleteName(int index){
    globals.namedataG.removeAt(index);
    globals.flagG.removeAt(index);
    setState((){});
  }

  List<bool> _flag = globals.flagG;

  Widget build(BuildContext context) {
    List<String> namedata = globals.namedataG;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(8.0),
            icon:Icon(Icons.edit),
            onPressed:(){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Test()
                )
              );
            },
          ),
          IconButton(
            padding: const EdgeInsets.all(8.0),
            icon:Icon(Icons.add),
            onPressed:(){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Add()
                )
              );
            },
          ),
        ],
        title: Text("名前編集"),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Action!',
        child: Icon(Icons.tap_and_play), 
        onPressed: () {
          //globals.inputText = "AAAAA";
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
                color: Colors.red,
                iconWidget: Text(
                  "削除",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {deleteName(index);}// _showSnackBar('Delete'),
              ),
            ]
          );
        }
      ),
    );
  }
}