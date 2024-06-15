[![pub package](https://img.shields.io/pub/v/drawerbehavior.svg)](https://pub.dartlang.org/packages/drawerbehavior)
![fdsfd](https://github.com/shiburagi/Drawer-Behavior-Flutter/workflows/Dart%20CI/badge.svg)


# Drawer Behavior - Flutter

Drawer behavior is a library that provide an extra behavior on drawer, such as, move view or scaling view's height while drawer on slide.

![Alt Text](https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-gif.gif)


---

**Code Base & Credit :**
https://github.com/matthew-carroll/flutter_ui_challenge_zoom_menu

---


## Table of contents
- [Drawer Behavior - Flutter](#drawer-behavior---flutter)
  - [Table of contents](#table-of-contents)
    - [Todo](#todo)
    - [NEW UPDATES](#new-updates)
  - [Usage](#usage)
    - [Android Native](#android-native)
  - [Drawer-Behavior](#drawer-behavior)
  - [Example](#example)
  - [## Migration (Null-safety Release)](#-migration-null-safety-release)
    - [mainDrawer (DrawerScaffold) -> defaultDirection (DrawerScaffold)](#maindrawer-drawerscaffold---defaultdirection-drawerscaffold)
  - [## Migration](#-migration)
    - [contentView (Screen) -> builder (ScreenBuilder)](#contentview-screen---builder-screenbuilder)
    - [menuView (MenuView) -> drawers (List\<SideDrawer>)](#menuview-menuview---drawers-listsidedrawer)
    - [percentage (DrawerScaffold) -> drawers (List\<SideDrawer>))](#percentage-drawerscaffold---drawers-listsidedrawer)
  - [Preview](#preview)
    - [Scale Effect](#scale-effect)
    - [Right Drawer](#right-drawer)
    - [3D Effect](#3d-effect)
    - [Drawer with Header](#drawer-with-header)
    - [Drawer with Footer](#drawer-with-footer)
    - [Drawer with Header and Custom Builder](#drawer-with-header-and-custom-builder)
    - [Peek Drawer](#peek-drawer)
  - [Customize](#customize)
  - [Contributor](#contributor)


### Todo 
 https://github.com/shiburagi/Drawer-Behavior-Flutter/projects/1


### NEW UPDATES

**Version 2.3**
- Peek Menu
- ClassName.identifier: **SideDrawer.count()**, **SideDrawer.child()** and **SideDrawer.custom()**
- Uncontrol SideDrawer

**Version 2.0**
- Sound null-safety

**Version 1.0**
- Elevation Config
- 3D effect
- Multi-Drawer
- Right Drawer

**Version 0.0**
- Floating action button with location and animator
- Bottom navigation bar
- Extended body
- AndroidX support  


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

## Example
```dart

class DrawerScale extends StatefulWidget {
  @override
  _DrawerScaleState createState() => _DrawerScaleState();
}

class _DrawerScaleState extends State<DrawerScale> {
  late int selectedMenuItemId;

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
## Migration (Null-safety Release)
--- <!-- no toc -->
### mainDrawer (DrawerScaffold) -> defaultDirection (DrawerScaffold)
```dart
new DrawerScaffold(
  mainDrawer: Direction.right,
  ...
);
```
**to**
```dart
new DrawerScaffold(
  defaultDirection: Direction.right,
  ...
);
```
--- <!-- no toc -->

## Migration
--- <!-- no toc -->
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
--- <!-- no toc -->
### menuView (MenuView) -> drawers (List\<SideDrawer>)
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
### percentage (DrawerScaffold) -> drawers (List\<SideDrawer>))
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

### Scale Effect

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

### Right Drawer

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

### 3D Effect

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

### Drawer with Header

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-2.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  headerView: headerView(context),
  ...
);
```
---

### Drawer with Footer

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-4.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  footerView: footerView(context),
  ...
);
```
---

### Drawer with Header and Custom Builder

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-5.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  headerView: headerView(context),
  drawers: [
      SideDrawer(
        itemBuilder:
            (BuildContext context, MenuItem menuItem, bool isSelected) {
          return Container(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
                : Colors.transparent,
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Text(
              menuItem.title,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: isSelected ? Colors.black87 : Colors.white70),
            ),
          );
        }
      )
  ],
  ...
);
```
---

### Peek Drawer

<img src="https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-ios-6.png?raw=true" width="400px"/>

```dart
new DrawerScaffold(
  headerView: headerView(context),
  drawers: [
      SideDrawer(
        peekMenu: true,
        percentage: 1,
        menu: menuWithIcon,
        direction: Direction.left,
      )
  ],
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
PreferredSizeWidget appBar;
double cornerRadius; // default: 16
double bacgroundColor; // default: Theme.of(context).scaffoldBackgroundColor
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

/// Listen to offset value on slide event for which [SideDrawer]
Function(SideDrawer, double) onSlide;
/// Listen to which [SideDrawer] is opened (offset=1)
Function(SideDrawer) onOpened;
/// Listen to which [SideDrawer] is closed (offset=0)
Function(SideDrawer) onClosed;
```
*SideDrawer*
```dart
double percentage; // default: 0.8
double elevation; // default: 4
double cornerRadius;
double degree; // 15-45 degree
double peekSize; // 56px
Menu menu;
String selectedItemId;
Direction direction;
Duration duration;
Curve curve;
bool animation; //default: false
bool slide; //default: false
bool peekMenu; //default: false
bool hideOnItemPressed; //default: true
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

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
