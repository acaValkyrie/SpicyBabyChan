import 'package:flutter/material.dart';
import 'globals.dart' as globals;


class TestWidget extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<TestWidget> {

  initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("開発用ページ09/09"),),
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

}
