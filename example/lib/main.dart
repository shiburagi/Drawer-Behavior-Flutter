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
  Widget createButton(context, {text, navigate, color}) {
    return SizedBox(
        width: double.infinity,
        child: RaisedButton(
            child: Text(text),
            color: color,
            onPressed: () {
              Navigator.pushNamed(context, navigate);
            }));
  }

  Widget home(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drawer Behavior"),
      ),
      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              createButton(context,
                  text: "Scale",
                  navigate: "/drawer1",
                  color: Theme.of(context).accentColor),
              createButton(context,
                  text: "Scale - no animation",
                  navigate: "/drawer2",
                  color: Theme.of(context).accentColor),
              Divider(height: 16, color: Theme.of(context).dividerColor),
              createButton(context,
                  text: "Scale - Menu Align Top",
                  navigate: "/drawer3",
                  color: Theme.of(context).accentColor),
              createButton(context,
                  text: "Scale - with Header View",
                  navigate: "/drawer4",
                  color: Theme.of(context).accentColor)
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.teal, accentColor: Colors.amberAccent),
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
