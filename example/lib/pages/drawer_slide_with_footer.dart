import 'package:drawerbehavior_example/menus/main.dart';
import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';

class DrawerSlideWithFooter extends StatefulWidget {
  @override
  _DrawerSlideWithFooterState createState() => _DrawerSlideWithFooterState();
}

class _DrawerSlideWithFooterState extends State<DrawerSlideWithFooter> {
  int selectedMenuItemId;

  @override
  void initState() {
    selectedMenuItemId = menu.items[0].id;
    super.initState();
  }

  Widget footerView(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(
          color: Colors.white.withAlpha(200),
          height: 16,
        ),
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
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        "test123@gmail.com",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.white.withAlpha(200)),
                      )
                    ],
                  ))
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      percentage: 1,
      cornerRadius: 0,
      appBar: AppBar(
          title: Text("Drawer - with Footer"),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      drawers: [
        MenuView(
          menu: menu,
          footerView: footerView(context),
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
