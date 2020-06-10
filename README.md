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
- [x] 3D effect
- [ ] Material design drawer's behavior


### NEW UPDATES
---
**Version 1.0**
- Elevation Config
- 3D effect
- Multi-Drawer
- Right Drawer
---
**Version 0.0**
- Floating action button with location and animator
- Bottom navigation bar
- Extended body
- AndroidX support  
---

## Table of contents
- [Usage](#usage)
- [Example](#example)
- [Migration](#migration)
- [Preview](#preview)
- [Customize](#customize)
- [Contributor](#contributor)


## Usage

1. **Depend on it**

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  drawerbehavior: latest_version
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
      appBar: AppBar(
          title: Text("Drawer - Scale"),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
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



## Migration
---
### contentView (Screen) -> builder (ScreenBuilder)
```dart
contentView: Screen(
  contentBuilder: (context) => Center(child: _widget),
  color: Colors.white,
),
```
**to**
```dart
builder: (context, id) => Center(child: _widget),
```
---
### menuView (MenuView) -> drawers (List<SideDrawer>)
```dart
menuView: new MenuView(
    menu: menu,
    headerView: headerView(context),
    animation: false,
    mainAxisAlignment: MainAxisAlignment.start,
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
```
**to**
```dart
drawers: [
  SideDrawer(
    menu: menu,
    direction: Direction.left, // Drawer position, left or right
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
```



---
### percentage (DrawerScaffold -> drawers (List<SideDrawer>))
```dart
DrawerScaffold(
  percentage: 0.6,
  ...
);
```
**to**
```dart
DrawerScaffold(
  drawers: [
    SideDrawer(
      percentage: 0.6,
      ...
    )
  ]  
  ...
);
```
---
 

## Preview

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-1.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  drawers: [
    SideDrawer(
      percentage: 0.6,
      ...
    )
  ]
  ...
);
```
---

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview_ios_scale_right.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  drawers: [
    SideDrawer(
      direction:Direction.right
      ...
    )
  ]
  ...
);
```
---

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview_ios_3d.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  drawers: [
    SideDrawer(
      degree: 45,
      ...
    )
  ]
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
bool enableGestures; // default: true
AppBar appBar;
double cornerRadius; // default: 16
Widget floatingActionButton;
Widget bottomNavigationBar;
FloatingActionButtonLocation floatingActionButtonLocation;
FloatingActionButtonAnimator floatingActionButtonAnimator;
List<BoxShadow> contentShadow;
Widget bottomSheet;
bool extendBodyBehindAppBar;
List<Widget> persistentFooterButtons;
bool primary;
bool resizeToAvoidBottomInset;
bool resizeToAvoidBottomPadding;
```
*SideDrawer*
```dart
double percentage; // default: 0.8
double elevation; // default: 4
double cornerRadius;
double degree; // 15-45 degree
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

## Contributor
- [Vladimir Vlach](https://github.com/vladaman)
- [trademunch](https://github.com/trademunch)
