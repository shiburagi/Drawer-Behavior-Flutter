[![pub package](https://img.shields.io/pub/v/drawerbehavior.svg)](https://pub.dartlang.org/packages/drawerbehavior)

# drawerbehavior

![Alt Text](https://github.com/shiburagi/Drawer-Behavior-Flutter/blob/preview/preview-android-gif.gif)


**Code Base :**
https://github.com/matthew-carroll/flutter_ui_challenge_zoom_menu

### Todo
- [x] Radius Parameter
- [ ] Right Menu View 
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
  percentage: 0.6,
  headerView: headerView(context),
  ...
);
```
---

## Customize

*DrawerScaffold*
```dart
final MenuView menuView;
final Screen contentView;
final AppBarProps appBar;
final double percentage;
final double cornerRadius;
```

*Screen*
```dart
final String title;
final DecorationImage background;
final WidgetBuilder contentBuilder;
final Color color;
final Color appBarColor;
```

*MenuView*
```dart
final Menu menu;
final String selectedItemId;
final bool animation;
final Function(String) onMenuItemSelected;
final Widget headerView;
final DecorationImage background;
final Color color;
Color selectorColor;
TextStyle textStyle;
final MainAxisAlignment mainAxisAlignment;
final EdgeInsets padding;
```

*MenuItem*
```dart
final String id;
final String title;
```

*AppBarProps*
```dart
final Icon leadingIcon;
final bool automaticallyImplyLeading;
final List<Widget> actions;
final Widget flexibleSpace;
final PreferredSizeWidget bottom;
final double elevation;
final Brightness brightness;
final IconThemeData iconTheme;
final TextTheme textTheme;
final bool primary;
final bool centerTitle;
final double titleSpacing;
final double toolbarOpacity;
final double bottomOpacity;
final Color backgroundColor;
final Widget title;
```
