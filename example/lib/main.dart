import 'package:flutter/material.dart';
import 'package:drawerbehavior_example/pages/drawer_1.dart';
import 'package:drawerbehavior_example/pages/drawer_2.dart';
import 'package:drawerbehavior_example/pages/drawer_3.dart';
import 'package:drawerbehavior_example/pages/drawer_4.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget home(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawer Behavior"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
              child: Text("Drawer 1"),
              onPressed: () {
                Navigator.pushNamed(context, "/drawer1");
              }),
          RaisedButton(
              child: Text("Drawer 2"),
              onPressed: () {
                Navigator.pushNamed(context, "/drawer2");
              }),
          RaisedButton(
              child: Text("Drawer 3"),
              onPressed: () {
                Navigator.pushNamed(context, "/drawer3");
              }),
          RaisedButton(
              child: Text("Drawer 4"),
              onPressed: () {
                Navigator.pushNamed(context, "/drawer4");
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": home,
        "/drawer1": (context) => Drawer1(),
        "/drawer2": (context) => Drawer2(),
        "/drawer3": (context) => Drawer3(),
        "/drawer4": (context) => Drawer4(),
      },
    );
  }
}
