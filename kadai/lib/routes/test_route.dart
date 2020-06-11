import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<TestWidget> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(title: Text("開発用ページ"),),
    );
  }
}
