import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawer_scaffold.dart';

final menuScreenKey = new GlobalKey(debugLabel: 'MenuScreen');

class MenuView extends StatefulWidget {
  final Menu menu;
  final String selectedItemId;
  final bool animation;
  final Function(String) onMenuItemSelected;

  final Widget headerView;
  final DecorationImage background;
  final Color color;

  final Color selectorColor;

  final TextStyle textStyle;

  final MainAxisAlignment mainAxisAlignment;

  final EdgeInsets padding;

  MenuView({
    this.menu,
    this.headerView,
    this.selectedItemId,
    this.onMenuItemSelected,
    this.color = Colors.white,
    this.background,
    this.animation = false,
    this.selectorColor,
    this.textStyle,
    this.padding = const EdgeInsets.only(left: 40.0, top: 15.0, bottom: 15.0),
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: menuScreenKey);

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
//      setState(() {
      selectorYTop = newYTop;
      selectorYBottom = newYBottom;
//      });
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

    if (widget.headerView != null) {
      listItems
          .add(Container(width: double.infinity, child: widget.headerView));
    }
    final animationIntervalDuration = 0.5;
    final perListItemDelay =
        menuController.state != MenuState.closing ? 0.15 : 0.0;

    final millis = menuController.state != MenuState.closing
        ? 150 * widget.menu.items.length
        : 600;
    final maxDuration = (widget.menu.items.length - 1) * perListItemDelay +
        animationIntervalDuration;
    for (var i = 0; i < widget.menu.items.length; ++i) {
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd =
          animationIntervalStart + animationIntervalDuration;
      final isSelected = widget.menu.items[i].id == widget.selectedItemId;

      var listItem = new _MenuListItem(
        title: widget.menu.items[i].title,
        isSelected: isSelected,
        selectorColor: selectorColor,
        textStyle: textStyle,
        menuView: widget,
        onTap: () {
          widget.onMenuItemSelected(widget.menu.items[i].id);
          menuController.close();
        },
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

    return new Transform(
      transform: new Matrix4.translationValues(
        0.0,
        MediaQuery.of(context).padding.top,
        0.0,
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 100.0),
          child: Column(
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: listItems,
          ),
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
//              createMenuTitle(menuController),

              createMenuItems(menuController),
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
  final Function() onTap;
  final Color selectorColor;
  final TextStyle textStyle;
  final MenuView menuView;

  _MenuListItem(
      {this.title,
      this.isSelected,
      this.onTap,
      this.menuView,
      @required this.textStyle,
      @required this.selectorColor});

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle =
        textStyle.copyWith(color: isSelected ? selectorColor : textStyle.color);

    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : onTap,
      child: Container(
        width: double.infinity,
        decoration: ShapeDecoration(
            shape: Border(
                left: BorderSide(
                    color: isSelected ? selectorColor : Colors.transparent,
                    width: 5.0))),
        child: new Padding(
          padding: menuView.padding,
          child: new Text(
            title,
            style: _textStyle,
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

  MenuItem({
    this.id,
    this.title,
  });
}
