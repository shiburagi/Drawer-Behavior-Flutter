import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';


class Drawer2 extends StatefulWidget {
  @override
  _Drawer2State createState() => _Drawer2State();
}

class _Drawer2State extends State<Drawer2> {

  List<ScreenHiddenDrawer> items = new List();

  @override
  void initState() {
    items.add(new ScreenHiddenDrawer(
        itemMenu:
        new ItemHiddenMenu(
          name: "Home",
          colorTextUnSelected: Colors.white.withOpacity(0.5),
        ),
        screen:Text("1")));

    items.add(new ScreenHiddenDrawer(
        itemMenu:
        new ItemHiddenMenu(
          name: "List",
          colorTextUnSelected: Colors.white.withOpacity(0.5),
        ),
        screen:Text("2")));

    items.add(new ScreenHiddenDrawer(
        itemMenu:

        new ItemHiddenMenu(
          name: "Profile",
          colorTextUnSelected: Colors.white.withOpacity(0.5),
        ),
        screen:Text("1")
    ));

    items.add(new ScreenHiddenDrawer(
      itemMenu:

      new ItemHiddenMenu(
        name: "Sign Out",
        colorTextUnSelected: Colors.white.withOpacity(0.5),
        onTap: () {

        },
      ),
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return HiddenDrawerMenu(
        initPositionSelected: 0,
        screens: items,
        scale: 0.6,
        backgroundColorMenu: Theme
            .of(context)
            .primaryColor,
    );
  }
}
