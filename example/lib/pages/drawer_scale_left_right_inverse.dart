import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:drawerbehavior_example/menus/main.dart';
import 'package:flutter/material.dart';

class DrawerLeftAndRightInverse extends StatefulWidget {
  @override
  _DrawerLeftAndRightInverseState createState() => _DrawerLeftAndRightInverseState();
}

class _DrawerLeftAndRightInverseState extends State<DrawerLeftAndRightInverse> {
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
      appBar: AppBar(title: Text("Drawer - Left & Right"), actions: [
        IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              controller.toggle(Direction.left);
            })
      ]),
      defaultDirection: Direction.right,
      drawers: [
        SideDrawer(
          percentage: 0.6,
          menu: menu,
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
          color: Theme.of(context).colorScheme.secondary,
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
