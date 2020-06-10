import 'package:flutter/material.dart';
import 'add_route.dart';
import 'edit_route.dart';
import 'test_route.dart';
import 'package:vibration/vibration.dart';
import 'globals.dart' as globals;
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

//class HomeState extends State<Home> {
class HomeState extends State<Home> {
  
  void deleteName(int index){
    globals.namedataG.removeAt(index);
    globals.flagG.removeAt(index);
    setState((){});
  }

  List<bool> _flag = globals.flagG;
  

  Widget build(BuildContext context) {

    setState((){});

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
              this.setState(() {});
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
           Vibration.vibrate(duration: 500 ,amplitude: 128);
           setState(() { });
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
                onTap:() async {
                  Navigator.push(context,new MaterialPageRoute(
                      builder: (context){return Edit(index: index);}
                    )
                  );
                  this.setState(() {});
                },
              ),
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