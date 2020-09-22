import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:SpicyBabyChan/home.dart' as homes;

int index;

class Edit extends StatefulWidget {

  final int index;
  Edit({Key key, this.index}) : super(key: key);
  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit> {

  final inputController = TextEditingController();

  void changeName(String inputtext){
    globals.namedataG[widget.index] = inputtext;
    homes.setname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'Action!',
          child: Icon(Icons.add), 
          onPressed: () {
            if(inputController.text.length > 0){
              changeName(inputController.text);
              Navigator.pop(context);
            }
          }, 
        ),

        appBar:AppBar(title: Text("名前編集"),),

        body:Container(
          height: 100.0,
          width: double.infinity,
          color: Colors.grey[200],
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top:100.0,left:10.0,right:10.0),
          child: TextField(
            enabled: true,
            maxLength: 20, //最大文字数
            style: TextStyle(
              color: Colors.black,
              fontSize: 30.0,
              height: 1.0,
            ),
            obscureText: false,
            maxLines:1,
            decoration: const InputDecoration(     
              hintText: '名前',
            ),
            controller: inputController,
          ),
        ),
    );
  }
}