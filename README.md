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
- [ ] Right Menu View 
- [ ] 3D effect
- [ ] Material design drawer's behavior

### NEW UPDATES
* Floating action button with location and animator ([trademunch](https://github.com/trademunch)) 
* Bottom navigation bar
* Extended body
* AndroidX support  ([Vladimir Vlach](https://github.com/vladaman))

## Usage

1. **Depend on it**

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  drawerbehavior: latest_version
```

### Version 1.0.0 (ALPHA)
[Documentation](https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/Version-1.0.0/README.md)

```yaml
dependencies:
  drawerbehavior:
    git: https://github.com/shiburagi/Drawer-Behavior-Flutter.git
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
import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';

class Drawer4 extends StatefulWidget {
  @override
  _Drawer4State createState() => _Drawer4State();
}

class _Drawer4State extends State<Drawer4> {
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

  Widget headerView(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: <Widget>[
              new Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
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
                            .subhead
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        "test123@gmail.com",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.white.withAlpha(200)),
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

  @override
  Widget build(BuildContext context) {
    return new DrawerScaffold(
      percentage: 1,
      cornerRadius: 0,
      appBar: AppBarProps(
          title: Text("Drawer 4"),
          actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
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
      contentView: Screen(
        contentBuilder: (context) => Center(child: _widget),
        color: Colors.white,
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
MenuView menuView;
Screen contentView;
AppBarProps appBar;
bool showAppBar;
double percentage;
double cornerRadius;
```

*Screen*
```dart
String title;
DecorationImage background;
WidgetBuilder contentBuilder;
Color color;
Color appBarColor;
```

*MenuView*
```dart
Menu menu;
String selectedItemId;
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

*AppBarProps*
```dart
Icon leadingIcon;
bool automaticallyImplyLeading;
List<Widget> actions;
Widget flexibleSpace;
PreferredSizeWidget bottom;
double elevation;
Brightness brightness;
IconThemeData iconTheme;
TextTheme textTheme;
bool primary;
bool centerTitle;
double titleSpacing;
double toolbarOpacity;
double bottomOpacity;
Color backgroundColor;
Widget title;
```
