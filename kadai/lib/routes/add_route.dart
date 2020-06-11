import 'package:flutter/material.dart';
import 'globals.dart' as globals;
 
class AddWidget extends StatefulWidget {
  AddWidget({Key key}) : super(key: key);
  @override
  AddState createState() => AddState();
}

class AddState extends State<AddWidget> {

  final inputController = TextEditingController();

  void addName(String inputtext){
    globals.namedataG.add(inputtext);
    globals.flagG.add(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: 'Action!',
          child: Icon(Icons.add), 
          onPressed: () {
            if(inputController.text.length > 0){
              addName(inputController.text);
              Navigator.of(context).pop();
            }
          }, 
        ),

        appBar:AppBar(title: Text("名前追加"),),

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