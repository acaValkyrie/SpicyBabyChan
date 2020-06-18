import 'package:flutter/material.dart';
//import 'package:audio_service/audio_service.dart';
//import 'globals.dart' as globals;

class Test2Widget extends StatefulWidget {
  @override
  Test2State createState() => Test2State();
}

class Test2State extends State<Test2Widget> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Action!',
        child: Icon(Icons.stop), 
        onPressed: () {
          setState(() { });
        }
      ),
    );
  }
}