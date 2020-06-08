[![pub package](https://img.shields.io/pub/v/drawerbehavior.svg)](https://pub.dartlang.org/packages/drawerbehavior)

# Drawer Behavior - Flutter

Drawer behavior is a library that provide an extra behavior on drawer, such as, move view or scaling view's height while drawer on slide.

![Alt Text](https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-gif.gif)


---

**Code Base & Credit :**
https://github.com/matthew-carroll/flutter_ui_challenge_zoom_menu

---

### Todo
- [x] Radius Parameter
- [x] Right Menu View 
- [ ] 3D effect
- [ ] Material design drawer's behavior

## Usage

1. **Depend on it**

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  drawerbehavior: ^0.0.4
```

2. **Install it**

You can install packages from the command line:

with Flutter:

```
$ flutter packages get
```

Alternatively, your editor might support flutter packages get. Check the docs for your editor to learn more.

3. **Import it**

Now in your Dart code, you can use:

```dart
import 'package:drawerbehavior/drawerbehavior.dart';
```

---
### For **Android** : [Drawer-Behavior](https://github.com/shiburagi/Drawer-Behavior)
---


## Example
```dart

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
    return DrawerScaffold(
      percentage: 0.6,
      appBar: AppBar(
          title: Text("Drawer - Scale"),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
      drawers: [
        MenuView(
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


```


## Preview

### Android

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-android-1.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  percentage: 0.6,
  ...
);
```
---

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-android-2.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  percentage: 0.6,
  headerView: headerView(context),
  ...
);
```
---

### IOS
<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-1.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  percentage: 0.6,
  ...
);
```
---

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-2.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  headerView: headerView(context),
  ...
);
```
---

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-4.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  footerView: footerView(context),
  ...
);
```
---

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-5.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  headerView: headerView(context),
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
  }
  ...
);
```
---

## Customize

*DrawerScaffold*
```dart
DrawerScaffoldController controller;
List<SideDrawer> drawers;
ScreenBuilder builder;
bool enableGestures;
AppBar appBar;
bool showAppBar;
double percentage;
double cornerRadius;
Widget floatingActionButton;
Widget bottomNavigationBar;
FloatingActionButtonLocation floatingActionButtonLocation;
FloatingActionButtonAnimator floatingActionButtonAnimator;
```
*SideDrawer*
```dart
Menu menu;
String selectedItemId;
Direction direction;
bool animation;
Function(String) onMenuItemSelected;
Widget headerView;
Widget footerView;
DecorationImage background;
Color color;
Color selectorColor;
TextStyle textStyle;
Alignment alignment;
EdgeInsets padding;
Function(BuildContext, MenuItem, bool) itemBuilder;

```

*MenuItem*
```dart
String id;
String title;
IconData icon;
```
