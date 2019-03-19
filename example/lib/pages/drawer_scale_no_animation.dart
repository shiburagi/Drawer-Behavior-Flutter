import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

class DrawerScaleNoAnimation extends StatefulWidget {
  @override
  _DrawerScaleNoAnimationState createState() => _DrawerScaleNoAnimationState();
}

class _DrawerScaleNoAnimationState extends State<DrawerScaleNoAnimation> {
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

  @override
  Widget build(BuildContext context) {
    return new DrawerScaffold(
        percentage: 0.6,
        appBar: AppBarProps(
            title: Text("Drawer - Scale No Animaton"),
            actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
        menuView: new MenuView(
          menu: menu,
          animation: false,
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
        ));
  }
}
