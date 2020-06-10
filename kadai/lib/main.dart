import 'package:flutter/material.dart';
import 'root.dart';
//import 'package:provider/provider.dart';
//import 'dart:async';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kadai kenkyuu',
            debugShowCheckedModeBanner: false,
      theme: ThemeData(
              primaryColor: Colors.blueGrey[900],
      ),
      home: RootWidget(),
    );
  }
}

