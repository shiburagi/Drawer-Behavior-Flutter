import 'package:drawerbehavior_example/pages/drawer_3d.dart';
import 'package:drawerbehavior_example/pages/drawer_custom_item.dart';
import 'package:drawerbehavior_example/pages/drawer_scale.dart';
import 'package:drawerbehavior_example/pages/drawer_scale_icon.dart';
import 'package:drawerbehavior_example/pages/drawer_scale_left_right.dart';
import 'package:drawerbehavior_example/pages/drawer_scale_left_right_inverse.dart';
import 'package:drawerbehavior_example/pages/drawer_scale_no_animation.dart';
import 'package:drawerbehavior_example/pages/drawer_scale_right.dart';
import 'package:drawerbehavior_example/pages/drawer_slide.dart';
import 'package:drawerbehavior_example/pages/drawer_slide_custom_appbar.dart';
import 'package:drawerbehavior_example/pages/drawer_slide_with_footer.dart';
import 'package:drawerbehavior_example/pages/drawer_slide_with_header.dart';
import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                createButton(context,
                    text: "Scale",
                    navigate: "/drawer1",
                    color: Theme.of(context).accentColor),
                createButton(context,
                    text: "Scale - with Icon",
                    navigate: "/drawer6",
                    color: Theme.of(context).accentColor),
                createButton(context,
                    text: "Scale - no animation",
                    navigate: "/drawer2",
                    color: Theme.of(context).accentColor),
                createButton(context,
                    text: "3D",
                    navigate: "/drawer12",
                    color: Theme.of(context).accentColor),
                Divider(height: 16, color: Theme.of(context).dividerColor),
                Text("Align Top"),
                Divider(height: 16, color: Theme.of(context).dividerColor),
                createButton(context,
                    text: "Slide ",
                    navigate: "/drawer3",
                    color: Theme.of(context).accentColor),
                createButton(context,
                    text: "Slide - with Header View",
                    navigate: "/drawer4",
                    color: Theme.of(context).accentColor),
                createButton(context,
                    text: "Slide - with Footer View",
                    navigate: "/drawer8",
                    color: Theme.of(context).accentColor),
                Divider(height: 16, color: Theme.of(context).dividerColor),
                Text("Duo Drawer"),
                Divider(height: 16, color: Theme.of(context).dividerColor),
                createButton(context,
                    text: "Left & Right",
                    navigate: "/drawer9",
                    color: Theme.of(context).accentColor),
                createButton(context,
                    text: "Left & Right (Inverse)",
                    navigate: "/drawer11",
                    color: Theme.of(context).accentColor),
                createButton(context,
                    text: "Right",
                    navigate: "/drawer10",
                    color: Theme.of(context).accentColor),
                Divider(height: 16, color: Theme.of(context).dividerColor),
                Text("Customize"),
                Divider(height: 16, color: Theme.of(context).dividerColor),
                createButton(context,
                    text: "Customize Item",
                    navigate: "/drawer5",
                    color: Theme.of(context).accentColor),
                createButton(context,
                    text: "Custom AppBar",
                    navigate: "/drawer7",
                    color: Theme.of(context).accentColor),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.teal, accentColor: Colors.amberAccent),
      routes: {
        "/": home,
        "/drawer1": (context) => DrawerScale(),
        "/drawer2": (context) => DrawerScaleNoAnimation(),
        "/drawer3": (context) => DrawerSlide(),
        "/drawer4": (context) => DrawerSlideWithHeader(),
        "/drawer5": (context) => DrawerCustomItem(),
        "/drawer6": (context) => DrawerScaleIcon(),
        "/drawer7": (context) => DrawerSlideCustomAppBar(),
        "/drawer8": (context) => DrawerSlideWithFooter(),
        "/drawer9": (context) => DrawerLeftAndRight(),
        "/drawer10": (context) => DrawerRight(),
        "/drawer11": (context) => DrawerLeftAndRightInverse(),
        "/drawer12": (context) => Drawer3d(),

      },
    );
  }
}
