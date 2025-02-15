import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

class DrawerCustomItemByCount extends StatefulWidget {
  const DrawerCustomItemByCount({Key? key}) : super(key: key);

  @override
  State<DrawerCustomItemByCount> createState() =>
      _DrawerCustomItemByCountState();
}

class _DrawerCustomItemByCountState extends State<DrawerCustomItemByCount> {
  final DrawerScaffoldController controller = DrawerScaffoldController();
  @override
  void initState() {
    super.initState();
  }

  Widget headerView(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 400,
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: <Widget>[
              Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
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
                            .titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        "test123@gmail.com",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
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

  int itemCount = 10;
  @override
  Widget build(BuildContext context) {
    return DrawerScaffold(
      controller: controller,
      cornerRadius: 0,
      appBar: AppBar(
          title: Text("Drawer - Custom Item by Count"),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      drawers: [
        SideDrawer.count(
          selectedItemId: 0,
          itemCount: itemCount,
          percentage: 1,
          headerView: headerView(context),
          alignment: Alignment.topLeft,
          color: Theme.of(context).primaryColor,
          builder: (BuildContext context, int index, bool isSelected) {
            return Container(
              color: isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .secondary
                      .withAlpha((255 * 0.7).toInt())
                  : Colors.transparent,
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Text(
                "Item $index",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? Colors.black87 : Colors.white70),
              ),
            );
          },
        )
      ],
      builder: (context, id) => IndexedStack(
        index: id,
        children: List.generate(
            itemCount,
            (e) => Center(
                  child: Text("Page~$e"),
                )).toList(),
      ),
    );
  }
}
