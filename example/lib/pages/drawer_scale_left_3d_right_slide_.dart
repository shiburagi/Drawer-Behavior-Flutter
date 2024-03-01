import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:drawerbehavior_example/menus/main.dart';
import 'package:flutter/material.dart';

class DrawerLeft3DAndRightSlide extends StatefulWidget {
  @override
  _DrawerLeft3DAndRightSlideState createState() => _DrawerLeft3DAndRightSlideState();
}

class _DrawerLeft3DAndRightSlideState extends State<DrawerLeft3DAndRightSlide> {
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
      appBar: AppBar(title: Text("Drawer - Left(3D) & Right(Slide)"), actions: [
        IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              controller.toggle(Direction.right);
            })
      ]),
      drawers: [
        SideDrawer(
          percentage: 0.6,
          degree: 45,
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
          cornerRadius: 0,
          menu: menu,
          percentage: 1.0,
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
