import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

class DrawerCustomItem extends StatefulWidget {
  @override
  _DrawerCustomItemState createState() => _DrawerCustomItemState();
}

class _DrawerCustomItemState extends State<DrawerCustomItem> {
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

  @override
  Widget build(BuildContext context) {
    return new DrawerScaffold(
      percentage: 1,
      cornerRadius: 0,
      appBar: AppBarProps(
          title: Text("Drawer - Custom  Item"),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      menuView: new MenuView(
        menu: menu,
        headerView: headerView(context),
        animation: false,
        alignment: Alignment.topLeft,
        color: Theme.of(context).primaryColor,
        selectedItemId: selectedMenuItemId,
        itemBuilder:
            (BuildContext context, MenuItem menuItem, bool isSelected) {
          return Container(
            color: isSelected
                ? Theme.of(context).accentColor.withOpacity(0.7)
                : Colors.transparent,
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Text(
              menuItem.title,
              style: Theme.of(context).textTheme.subhead.copyWith(
                  color: isSelected ? Colors.black87 : Colors.white70),
            ),
          );
        },
        onMenuItemSelected: (String itemId) {
          selectedMenuItemId = itemId;
          if (itemId == 'restaurant') {
            setState(() => _widget = Text("1"));
          } else {
            setState(() => _widget = Text("default"));
          }
        },
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
