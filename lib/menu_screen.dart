import 'package:drawerbehavior/drawer_scaffold.dart';
import 'package:flutter/material.dart';

final menuScreenKey = new GlobalKey(debugLabel: 'MenuScreen');

class MenuView extends StatefulWidget {
  MenuView({
    this.menu,
    this.headerView,
    this.contentView,
    this.footerView,
    this.selectedItemId,
    this.onMenuItemSelected,
    this.color = Colors.white,
    this.background,
    this.animation = false,
    this.selectorColor,
    this.textStyle,
    this.padding = const EdgeInsets.only(left: 40.0, top: 15.0, bottom: 15.0),
    this.alignment = Alignment.center,
    this.itemBuilder,
  }) : super(key: menuScreenKey);

  final double maxSlideAmount = 275.0;

  final Menu menu;
  final String selectedItemId;
  final bool animation;
  final Function(String) onMenuItemSelected;

  final Widget headerView;
  final Widget contentView;
  final Widget footerView;
  final Function(BuildContext, MenuItem, bool) itemBuilder;
  final DecorationImage background;
  final Color color;

  final Color selectorColor;
  final TextStyle textStyle;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  _MenuViewState createState() => new _MenuViewState();
}

class _MenuViewState extends State<MenuView> with TickerProviderStateMixin {
  AnimationController titleAnimationController;
  double selectorYTop;
  double selectorYBottom;

  Color selectorColor;
  TextStyle textStyle;

  setSelectedRenderBox(RenderBox newRenderBox, bool useState) async {
    final newYTop = newRenderBox.localToGlobal(const Offset(0.0, 0.0)).dy;
    final newYBottom = newYTop + newRenderBox.size.height;
    if (newYTop != selectorYTop) {
      selectorYTop = newYTop;
      selectorYBottom = newYBottom;
    }
  }

  @override
  void initState() {
    super.initState();
    titleAnimationController = new AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  createMenuTitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closed:
      case MenuState.closing:
        titleAnimationController.reverse();
        break;
    }

    return new AnimatedBuilder(
        animation: titleAnimationController,
        child: new OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.topLeft,
          child: new Padding(
            padding: const EdgeInsets.all(30.0),
            child: new Text(
              'Menu',
              style: new TextStyle(
                color: const Color(0x88444444),
                fontSize: 240.0,
                fontFamily: 'mermaid',
              ),
              textAlign: TextAlign.left,
              softWrap: false,
            ),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return new Transform(
            transform: new Matrix4.translationValues(
              250.0 * (1.0 - titleAnimationController.value) - 100.0,
              0.0,
              0.0,
            ),
            child: child,
          );
        });
  }

  createMenuItems(MenuController menuController) {
    final List<Widget> listItems = [];
    Menu menu = widget.menu ?? Menu(items: []);

    final animationIntervalDuration = 0.5;
    final perListItemDelay =
        menuController.state != MenuState.closing ? 0.15 : 0.0;

    final millis = menuController.state != MenuState.closing
        ? 150 * menu.items.length
        : 600;
    final maxDuration =
        (menu.items.length - 1) * perListItemDelay + animationIntervalDuration;
    for (var i = 0; i < menu.items.length; ++i) {
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd =
          animationIntervalStart + animationIntervalDuration;

      MenuItem item = menu.items[i];

      final isSelected = item.id == widget.selectedItemId;

      Function onTap = () {
        widget.onMenuItemSelected(item.id);
        menuController.close();
      };
      Widget listItem = widget.itemBuilder == null
          ? _MenuListItem(
              title: item.title,
              isSelected: isSelected,
              selectorColor: selectorColor,
              textStyle: textStyle,
              menuView: widget,
              icon: item.icon == null ? null : Icon(item.icon),
              onTap: onTap,
              drawBorder: !widget.animation,
            )
          : InkWell(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: widget.itemBuilder(context, item, isSelected),
                  width: widget.maxSlideAmount,
                ),
              ),
              onTap: onTap,
            );

//      print("$maxDuration, $animationIntervalEnd");

      if (widget.animation)
        listItems.add(new AnimatedMenuListItem(
          menuState: menuController.state,
          isSelected: isSelected,
          duration: Duration(milliseconds: millis),
          curve: new Interval(animationIntervalStart / maxDuration,
              animationIntervalEnd / maxDuration,
              curve: Curves.easeOut),
          menuListItem: listItem,
        ));
      else {
        listItems.add(listItem);
      }
    }

    return Container(
      alignment: widget.alignment,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: listItems,
        ),
      ),
    );
  }

  Widget createDrawer(MenuController menuController) {
    List<Widget> widgets = [];
    if (widget.headerView != null) {
      widgets.add(Container(width: double.infinity, child: widget.headerView));
    }
    widgets.add(Expanded(
      child: widget.contentView == null
          ? createMenuItems(menuController)
          : Container(
              child: Container(
                child: widget.contentView,
                width: widget.maxSlideAmount,
              ),
              alignment: Alignment.topRight,
            ),
      flex: 1,
    ));

    if (widget.footerView != null) {
      widgets.add(Container(
        width: double.infinity,
        child: widget.footerView,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      ));
    }
    return Transform(
      transform: new Matrix4.translationValues(
        0.0,
        MediaQuery.of(context).padding.top,
        0.0,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    selectorColor = widget?.selectorColor ?? Theme.of(context).indicatorColor;
    textStyle = widget?.textStyle ??
        Theme.of(context).textTheme.subtitle.copyWith(
            color: widget.color.computeLuminance() < 0.5
                ? Colors.white
                : Colors.black);
    return new DrawerScaffoldMenuController(
        builder: (BuildContext context, MenuController menuController) {
      var shouldRenderSelector = true;
      var actualSelectorYTop = selectorYTop;
      var actualSelectorYBottom = selectorYBottom;
      var selectorOpacity = 1.0;

      if (menuController.state == MenuState.closed ||
          menuController.state == MenuState.closing ||
          selectorYTop == null) {
        final RenderBox menuScreenRenderBox =
            context.findRenderObject() as RenderBox;

        if (menuScreenRenderBox != null) {
          final menuScreenHeight = menuScreenRenderBox.size.height;
          actualSelectorYTop = menuScreenHeight - 50.0;
          actualSelectorYBottom = menuScreenHeight;
          selectorOpacity = 0.0;
        } else {
          shouldRenderSelector = false;
        }
      }

      return new Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
          image: widget.background,
          color: widget.color,
        ),
        child: new Material(
          color: Colors.transparent,
          child: new Stack(
            children: [
              createDrawer(menuController),
              widget.animation && shouldRenderSelector
                  ? new ItemSelector(
                      selectorColor: selectorColor,
                      topY: actualSelectorYTop,
                      bottomY: actualSelectorYBottom,
                      opacity: selectorOpacity)
                  : new Container(),
            ],
          ),
        ),
      );
    });
  }
}

class ItemSelector extends ImplicitlyAnimatedWidget {
  final double topY;
  final double bottomY;
  final double opacity;

  final Color selectorColor;

  ItemSelector({
    this.topY,
    this.bottomY,
    this.opacity,
    this.selectorColor,
  }) : super(duration: const Duration(milliseconds: 250));

  @override
  _ItemSelectorState createState() => new _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  Tween<double> _topY;
  Tween<double> _bottomY;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor visitor) {
    _topY = visitor(
      _topY,
      widget.topY,
      (dynamic value) => new Tween<double>(begin: value),
    );
    _bottomY = visitor(
      _bottomY,
      widget.bottomY,
      (dynamic value) => new Tween<double>(begin: value),
    );
    _opacity = visitor(
      _opacity,
      widget.opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: _topY.evaluate(animation),
      child: new Opacity(
        opacity: _opacity.evaluate(animation),
        child: new Container(
          width: 5.0,
          height: _bottomY.evaluate(animation) - _topY.evaluate(animation),
          color: widget.selectorColor,
        ),
      ),
    );
  }
}

class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final MenuState menuState;
  final bool isSelected;
  final Duration duration;

  AnimatedMenuListItem({
    this.menuListItem,
    this.menuState,
    this.isSelected,
    this.duration,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => new _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;

  updateSelectedRenderBox(bool useState) {
    final renderBox = context.findRenderObject() as RenderBox;
    if (renderBox != null && widget.isSelected) {
      (menuScreenKey.currentState as _MenuViewState)
          .setSelectedRenderBox(renderBox, useState);
    }
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.closed:
      case MenuState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;
      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => new Tween<double>(begin: value),
    );

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox(false);

    return new Opacity(
      opacity: _opacity.evaluate(animation),
      child: new Transform(
        transform: new Matrix4.translationValues(
          0.0,
          _translation.evaluate(animation),
          0.0,
        ),
        child: widget.menuListItem,
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool drawBorder;
  final Function() onTap;
  final Color selectorColor;
  final TextStyle textStyle;
  final MenuView menuView;
  final Widget icon;

  _MenuListItem(
      {this.title,
      this.isSelected,
      this.onTap,
      this.menuView,
      @required this.textStyle,
      @required this.selectorColor,
      this.icon,
      this.drawBorder});

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle =
        textStyle.copyWith(color: isSelected ? selectorColor : textStyle.color);

    List<Widget> children = [];
    if (icon != null)
      children.add(Padding(
        padding: EdgeInsets.only(right: 12),
        child: IconTheme(
            data: IconThemeData(color: _textStyle.color), child: icon),
      ));
    children.add(
      Expanded(
        child: new Text(
          title,
          style: _textStyle,
        ),
        flex: 1,
      ),
    );
    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : onTap,
      child: Container(
        width: double.infinity,
        decoration: drawBorder
            ? ShapeDecoration(
                shape: Border(
                  left: BorderSide(
                      color: isSelected ? selectorColor : Colors.transparent,
                      width: 5.0),
                ),
              )
            : null,
        child: new Padding(
          padding: menuView.padding,
          child: Row(
            children: children,
          ),
        ),
      ),
    );
  }
}

class Menu {
  final List<MenuItem> items;

  Menu({
    this.items,
  });
}

class MenuItem {
  final String id;
  final String title;
  final IconData icon;

  MenuItem({
    this.id,
    this.title,
    this.icon,
  });
}
