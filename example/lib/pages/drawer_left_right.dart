import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

class DrawerLeftAndRight extends StatefulWidget {
  @override
  _DrawerLeftAndRightState createState() => _DrawerLeftAndRightState();
}

class _DrawerLeftAndRightState extends State<DrawerLeftAndRight> {
  final menu = new Menu(
    items: [
      new MenuItem(
        id: 'restaurant',
        title: 'THE PADDOCK',
      ),
      new MenuItem(
        id: 'other1',
        title: 'THE HERO',
      ),
      new MenuItem(
        id: 'other2',
        title: 'HELP US GROW',
      ),
      new MenuItem(
        id: 'other3',
        title: 'SETTINGS',
      ),
    ],
  );

  var selectedMenuItemId = 'restaurant';
  var _widget = Text("1");

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
        ),
        Divider(
          color: Colors.white.withAlpha(200),
          height: 16,
        )
      ],
    );
  }

  DrawerScaffoldController _controller = DrawerScaffoldController();

  @override
  Widget build(BuildContext context) {
    return new DrawerScaffold(
      percentage: 1,
      controller: _controller,
      cornerRadius: 0,
      appBar: AppBarProps(
        title: Text("Drawer - with Header"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _controller.focusDrawer = DrawerGravity.right;
                _controller.toggle();
              });
            },
          ),
        ],
      ),
      menuView: new MenuView(
        menu: menu,
        headerView: headerView(context),
        animation: false,
        alignment: Alignment.topLeft,
        color: Theme.of(context).primaryColor,
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: (String itemId) {
          selectedMenuItemId = itemId;
          if (itemId == 'restaurant') {
            setState(() => _widget = Text("1"));
          } else {
            setState(() => _widget = Text("default"));
          }
        },
      ),
      rightMenuView: MenuView(
        contentView: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 32, top: 16, bottom: 8),
              child: Text(
                "Notifications",
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.black54),
              ),
            ),
            Divider(
              color: Colors.black54,
              height: 12,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
      contentView: Screen(
        contentBuilder: (context) => LayoutBuilder(
              builder: (context, constraint) => GestureDetector(
                    child: Container(
                      color: Colors.white,
                      width: constraint.maxWidth,
                      height: constraint.maxHeight,
                      child: Center(child: _widget),
                    ),
                    onTap: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Clicked"),
                        duration: Duration(seconds: 3),
                      ));
                    },
                  ),
            ),
        color: Colors.white,
      ),
    );
  }
}
