import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:drawerbehavior_example/menus/main.dart';
import 'package:flutter/material.dart';

class DrawerScaleGradient extends StatefulWidget {
  const DrawerScaleGradient({Key? key}) : super(key: key);

  @override
  State<DrawerScaleGradient> createState() => _DrawerScaleGradientState();
}

class _DrawerScaleGradientState extends State<DrawerScaleGradient> {
  int? selectedMenuItemId;

  @override
  void initState() {
    selectedMenuItemId = menu.items[0].id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DrawerScaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text("Drawer - Scale"),
            actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
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
            percentage: 0.6,
            menu: menu,
            direction: Direction.left,
            animation: true,
            color: Colors.transparent,
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
      ),
    );
  }
}
