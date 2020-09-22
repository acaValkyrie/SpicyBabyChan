import 'package:flutter/material.dart';
import 'home.dart';
import 'routes/add_route.dart';
import 'routes/test_route.dart';
//import 'routes/test_route2.dart';
 
 
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
      home: new HomeWidget(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomeWidget(),
        '/option': (BuildContext context) => OptionWidget(),
        '/add': (BuildContext context) => AddWidget(),
        '/test': (BuildContext context) => TestWidget(),
        //'/test2': (BuildContext context) => Test2Widget(),
      },
    );
  }
}

