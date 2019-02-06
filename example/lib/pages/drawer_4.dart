import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';


class Drawer4 extends StatefulWidget {
  @override
  _Drawer4State createState() => _Drawer4State();
}

class _Drawer4State extends State<Drawer4> {

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
        borderRadius: 15,
        scale: 0.6,
        screens: items,
        backgroundColorMenu: Theme
            .of(context)
            .primaryColor,
    );
  }
}
