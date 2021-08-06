import 'package:drawerbehavior_example/menus/main.dart';
import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';

class DrawerSlideWithHeader extends StatefulWidget {
  @override
  _DrawerSlideWithHeaderState createState() => _DrawerSlideWithHeaderState();
}

class _DrawerSlideWithHeaderState extends State<DrawerSlideWithHeader> {
  late int selectedMenuItemId;

  @override
  void initState() {
    selectedMenuItemId = menu.items[0].id;
    super.initState();
  }

  Widget headerView(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: <Widget>[
              new Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/user1.jpg")))),
              Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "John Witch",
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        "test123@gmail.com",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            ?.copyWith(color: Colors.white.withAlpha(200)),
                      )
                    ],
                  ))
            ],
          ),
        ),
        Divider(
          color: Colors.white.withAlpha(200),
          height: 16,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new DrawerScaffold(
      cornerRadius: 0,
      appBar: AppBar(
          title: Text("Drawer - with Header"),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      drawers: [
        SideDrawer(
          // withSafeAre: false,
          percentage: 1,
          menu: menu,
          headerView: headerView(context),
          animation: false,
          alignment: Alignment.topLeft,
          color: Theme.of(context).primaryColor,
          selectedItemId: selectedMenuItemId,
          onMenuItemSelected: (itemId) {
            setState(() {
              selectedMenuItemId = itemId;
            });
          },
        )
      ],
      builder: (context, id) => IndexedStack(
        index: id,
        children: menu.items
            .map((e) => Center(
                  child: Text("Page~${e.title}"),
                ))
            .toList(),
      ),
    );
  }
}
