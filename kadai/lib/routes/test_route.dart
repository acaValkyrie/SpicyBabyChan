import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class Test extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<Test> {

  

  @override
  Widget build(BuildContext context) {

    setState((){});

    String inputtext = globals.inputText;
    bool record = globals.recordflag;
    
    if (record) {
      return Scaffold(
        appBar:AppBar(title: Text("開発用ページ"),),

        floatingActionButton: FloatingActionButton(
          tooltip: 'Action!',
          child: Icon(Icons.mic), 
          onPressed: (){},
          backgroundColor: Colors.red,
        ),

        body: Container(
          height: 400.0,
          width: double.infinity,
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey) 
          ),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top:50.0,left:20.0,right:20.0),
          child: Text(
            inputtext,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              height: 1.0,
            ),
            maxLines:10,
          ),
        ),
      );
    }

    else return Scaffold(
      appBar:AppBar(title: Text("開発用ページ"),),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Action!',
        child: Icon(Icons.mic), 
        onPressed: (){},
        backgroundColor: Colors.black,
      ),

      body: Container(
        height: 400.0,
        width: double.infinity,
         decoration: new BoxDecoration(
          border: new Border.all(color: Colors.grey) 
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(top:50.0,left:20.0,right:20.0),
        child: Text(
          inputtext,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            height: 1.0,
          ),
          maxLines:10,
        ),
      ),
    );
  }
}
