import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:drawerbehavior_example/menus/main.dart';
import 'package:flutter/material.dart';

class DrawerScale extends StatefulWidget {
  @override
  _DrawerScaleState createState() => _DrawerScaleState();
}

class _DrawerScaleState extends State<DrawerScale> {
  int selectedMenuItemId;

  @override
  void initState() {
    selectedMenuItemId = menu.items[0].id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new DrawerScaffold(
      percentage: 0.6,
      appBar: AppBar(
          title: Text("Drawer - Scale"),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      menuView: new MenuView(
        menu: menu,
        animation: true,
        color: Theme.of(context).primaryColor,
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: (itemId) {
          setState(() {
            selectedMenuItemId = itemId;
          });
        },
      ),
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
