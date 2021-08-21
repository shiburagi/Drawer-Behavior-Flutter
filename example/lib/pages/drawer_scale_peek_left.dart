import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:drawerbehavior_example/menus/main.dart';
import 'package:flutter/material.dart';

class DrawerPeekLeft extends StatefulWidget {
  @override
  _DrawerPeekLeftState createState() => _DrawerPeekLeftState();
}

class _DrawerPeekLeftState extends State<DrawerPeekLeft> {
  int? selectedMenuItemId;
  DrawerScaffoldController controller = DrawerScaffoldController();
  @override
  void initState() {
    selectedMenuItemId = menu.items[0].id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      controller: controller,
      appBar: AppBar(title: Text("Drawer - Peek Left"), actions: [
        IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              controller.toggle(Direction.right);
            })
      ]),
      onSlide: (drawer, value) {
        debugPrint("[LOG] Drawer ${drawer.direction} $value");
      },
      onOpened: (drawer) {
        debugPrint("[LOG] Drawer ${drawer.direction} opened");
      },
      onClosed: (drawer) {
        debugPrint("[LOG] Drawer ${drawer.direction} closed");
      },
      drawers: [
        SideDrawer(
          peekMenu: true,
          percentage: 1,
          menu: menuWithIcon,
          direction: Direction.left,
          animation: true,
          color: Theme.of(context).primaryColor,
          selectedItemId: selectedMenuItemId,
          onMenuItemSelected: (itemId) {
            setState(() {
              selectedMenuItemId = itemId;
            });
          },
        ),
        SideDrawer(
          menu: menu,
          direction: Direction.right,
          animation: true,
          selectorColor: Colors.white,
          color: Theme.of(context).accentColor,
          selectedItemId: selectedMenuItemId,
          onMenuItemSelected: (itemId) {
            setState(() {
              selectedMenuItemId = itemId;
            });
          },
        ),
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
