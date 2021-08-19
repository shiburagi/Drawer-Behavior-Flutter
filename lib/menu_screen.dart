import 'dart:math';

import 'package:drawerbehavior/drawer_scaffold.dart';
import 'package:flutter/material.dart';

// final menuScreenKey = GlobalKey(debugLabel: 'MenuScreen');

enum Direction {
  left,
  right,
}

typedef SideDrawerItemBuilder = Function(BuildContext, MenuItem, bool);

class SideDrawer<T> extends StatefulWidget {
  SideDrawer({
    this.menu,
    this.headerView,
    this.footerView,
    this.selectedItemId,
    this.slide = false,
    double? percentage,
    double? degree,
    this.onMenuItemSelected,
    this.child,
    this.color = Colors.white,
    this.background,
    this.animation = false,
    this.direction = Direction.left,
    this.selectorColor,
    this.drawerWidth = 300,
    this.peekSize = 56,
    this.duration,
    this.curve,
    this.textStyle,
    EdgeInsets? padding,
    this.alignment = Alignment.centerLeft,
    this.itemBuilder,
    this.elevation = 16,
    this.cornerRadius,
    this.withSafeAre = true,
    Key? key,
    this.peekMenu = false,
    this.hideOnItemPressed = true,
  })  : assert((child != null && menu == null && itemBuilder == null) ||
            (child == null && menu != null)),
        this.percentage = percentage ?? 0.8,
        this.degree = degree == null ? null : max(min(45, degree), 15),
        this.scaleDownCurve =
            new Interval(0.0, 0.3, curve: curve ?? Curves.easeOut),
        this.scaleUpCurve =
            new Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.slideOutCurve =
            new Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.slideInCurve =
            new Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.padding = padding ??
            (peekMenu
                ? const EdgeInsets.only(left: 16.0, top: 15.0, bottom: 15.0)
                : const EdgeInsets.only(left: 40.0, top: 15.0, bottom: 15.0)),
        super(key: key);

  /// Scaling Percentage base on width and height
  final double percentage;

  /// Card's elevation
  /// Default : 16
  final double elevation;

  /// Card's corner radius
  final double? cornerRadius;

  /// Degree of rotation : 15->45 degree
  final double? degree;

  /// peekSize
  final double peekSize;

  /// Drawer's width in Pixel,
  /// Default : 300px
  final double drawerWidth;

  /// Direction the drawer will appear ([Direction.left] or [Direction.right])
  /// Default: [Direction.left]
  final Direction direction;

  /// Transition's [Curve],
  /// Default : [Curves.easeOut]
  final Curve? curve;

  /// Transition's [Duration],
  /// Defalut: 250ms
  final Duration? duration;

  /// [Menu] for drawer
  final Menu? menu;

  /// Current selected ID
  final T? selectedItemId;

  /// Flag for animation on menu item
  final bool animation;

  // peek
  final bool peekMenu;

  // close drawer when menu clicked, default : true
  final bool hideOnItemPressed;

  /// Flag for drawer slide with main container
  final bool slide;

  /// listen to menu selected
  final Function(T)? onMenuItemSelected;

  /// [Widget] for header on drawer
  final Widget? headerView;

  /// [Widget] for footer on drawer
  final Widget? footerView;

  /// Custom builder for menu item
  final SideDrawerItemBuilder? itemBuilder;

  /// Widget for side drawer
  final Widget? child;

  /// Background for drawer
  final DecorationImage? background;

  /// Background [Color] for drawer
  final Color color;

  /// [Color] for selected menu item
  final Color? selectorColor;

  /// Menu item [TextStyle]
  final TextStyle? textStyle;

  /// Menu [Alignment] in drawer
  final Alignment alignment;

  /// Menu [Padding] in drawer
  final EdgeInsets padding;

  /// Easing [Curve] for scale down
  final Curve scaleDownCurve;

  /// Easing [Curve] for scale up
  final Curve scaleUpCurve;

  /// Easing [Curve] for slide out
  final Curve slideOutCurve;

  /// Easing [Curve] for slide in
  final Curve slideInCurve;

  /// to enable/disable [SafeArea] for headerView & footerView, default = true
  final bool withSafeAre;

  double maxSlideAmount(context) =>
      drawerWidth; // ?? MediaQuery.of(context).size.width * percentage;

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> with TickerProviderStateMixin {
  double? selectorYTop;
  double? selectorYBottom;

  Color? selectorColor;
  TextStyle? textStyle;

  double get maxSlideAmount => widget.maxSlideAmount(context);

  setSelectedRenderBox(RenderBox newRenderBox, bool useState) async {
    final renderBox = context.findRenderObject() as RenderBox?;

    final newYTop =
        newRenderBox.localToGlobal(Offset(0.0, 0.0), ancestor: renderBox).dy;

    final newYBottom = newYTop + newRenderBox.size.height;
    if (newYTop != selectorYTop) {
      selectorYTop = newYTop;
      selectorYBottom = newYBottom;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget createMenuItems(MenuController menuController) {
    final List<Widget> listItems = [];

    if (widget.child != null) {
      listItems.add(widget.child ?? SizedBox());
    } else {
      final animationIntervalDuration = 0.5;
      final perListItemDelay =
          menuController.state != MenuState.closing ? 0.15 : 0.0;
      final millis = menuController.state != MenuState.closing
          ? 150 * widget.menu!.items.length
          : 600;

      final maxDuration = (widget.menu!.items.length - 1) * perListItemDelay +
          animationIntervalDuration;

      for (var i = 0; i < widget.menu!.items.length; ++i) {
        final animationIntervalStart = i * perListItemDelay;
        final animationIntervalEnd =
            animationIntervalStart + animationIntervalDuration;
        MenuItem item = widget.menu!.items[i];
        listItems.add(buildListItem(menuController, item,
            animationIntervalStart, animationIntervalEnd, millis, maxDuration));
      }
    }

    return Container(
      alignment: widget.alignment,
      margin: EdgeInsets.only(
          left: widget.direction == Direction.left
              ? 0
              : MediaQuery.of(context).size.width - maxSlideAmount),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listItems,
          ),
        ),
      ),
    );
  }

  bool get useAnimation => widget.animation && !widget.peekMenu;
  buildListItem(
    MenuController menuController,
    MenuItem item,
    double animationIntervalStart,
    double animationIntervalEnd,
    int millis,
    double maxDuration,
  ) {
    final isSelected = item.id == widget.selectedItemId;

    Function onTap = () {
      widget.onMenuItemSelected?.call(item.id);
      if (widget.hideOnItemPressed) menuController.close();
    };
    Widget listItem = widget.itemBuilder == null
        ? _MenuListItem(
            padding: widget.peekMenu
                ? EdgeInsets.zero
                : const EdgeInsets.only(left: 32.0),
            direction: widget.direction,
            title: item.title,
            isSelected: isSelected,
            selectorColor: selectorColor,
            textStyle: item.textStyle ?? textStyle,
            menuView: widget,
            width: maxSlideAmount,
            icon: item.icon == null ? item.prefix : Icon(item.icon),
            suffix: item.suffix,
            onTap: onTap as dynamic Function()?,
            drawBorder: !useAnimation)
        : InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                child: widget.itemBuilder!(context, item, isSelected),
                width: maxSlideAmount,
              ),
            ),
            onTap: onTap as void Function()?,
          );

    if (useAnimation)
      return AnimatedMenuListItem(
        menuState: menuController.state,
        isSelected: isSelected,
        duration: Duration(milliseconds: millis),
        curve: Interval(animationIntervalStart / maxDuration,
            animationIntervalEnd / maxDuration,
            curve: Curves.easeOut),
        menuListItem: listItem,
      );
    else {
      return listItem;
    }
  }

  Widget createDrawer(MenuController menuController) {
    List<Widget> widgets = [];
    if (widget.headerView != null) {
      widgets.add(Container(
        alignment: widget.alignment,
        margin: EdgeInsets.only(
            left: widget.direction == Direction.left
                ? 0
                : MediaQuery.of(context).size.width - maxSlideAmount),
        child: Container(width: maxSlideAmount, child: widget.headerView),
      ));
    } else {}
    widgets.add(Expanded(
      child: createMenuItems(menuController),
      flex: 1,
    ));

    if (widget.footerView != null) {
      widgets.add(Container(
          alignment: widget.alignment,
          margin: EdgeInsets.only(
              left: widget.direction == Direction.left
                  ? 0
                  : MediaQuery.of(context).size.width - maxSlideAmount),
          child: Container(
            width: maxSlideAmount,
            child: widget.footerView,
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          )));
    }
    MenuController controller = DrawerScaffold.currentController(context);
    return Transform(
      transform: Matrix4.translationValues(
        widget.slide
            ? (widget.direction == Direction.left ? 1 : -1) *
                (widget.maxSlideAmount(context)) *
                (controller.slidePercent - 1)
            : 0,
        0,
        0.0,
      ),
      child: SafeArea(
        top: widget.withSafeAre || widget.headerView == null,
        bottom: widget.withSafeAre || widget.footerView == null,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: widgets,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    selectorColor = widget.selectorColor ?? Theme.of(context).indicatorColor;
    textStyle = widget.textStyle ??
        Theme.of(context).textTheme.subtitle1?.copyWith(
            color: widget.color.computeLuminance() < 0.5
                ? Colors.white
                : Colors.black);
    return DrawerScaffoldMenuController(
        direction: widget.direction,
        builder: (BuildContext context, MenuController menuController) {
          var shouldRenderSelector = true;
          var actualSelectorYTop = selectorYTop;
          var actualSelectorYBottom = selectorYBottom;
          var selectorOpacity = 1.0;

          if (menuController.state == MenuState.closed ||
              menuController.state == MenuState.closing ||
              selectorYTop == null) {
            final RenderBox? menuScreenRenderBox =
                context.findRenderObject() as RenderBox?;

            if (menuScreenRenderBox != null) {
              final menuScreenHeight = menuScreenRenderBox.size.height;
              actualSelectorYTop = menuScreenHeight - 50.0;
              actualSelectorYBottom = menuScreenHeight;
              selectorOpacity = 0.0;
            } else {
              shouldRenderSelector = false;
            }
          }

          return Container(
            // padding: widget.direction == Direction.right
            //     ? const EdgeInsets.only(left: 24)
            //     : const EdgeInsets.only(right: 24),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: widget.background,
              color: widget.color,
            ),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    createDrawer(menuController),
                    useAnimation && shouldRenderSelector
                        ? ItemSelector(
                            left: widget.direction == Direction.right
                                ? MediaQuery.of(context).size.width -
                                    maxSlideAmount
                                : 0,
                            selectorColor: selectorColor,
                            top: actualSelectorYTop,
                            bottom: actualSelectorYBottom,
                            opacity: selectorOpacity)
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static _SideDrawerState? of(BuildContext context, {bool nullOk = true}) {
    final _SideDrawerState? result =
        context.findAncestorStateOfType<_SideDrawerState>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          '_SideDrawerState.of() called with a context that does not contain a _SideDrawerState.'),
      context.describeElement('The context used was')
    ]);
  }
}

class ItemSelector extends ImplicitlyAnimatedWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? opacity;

  final Color? selectorColor;

  ItemSelector({
    this.left,
    this.top,
    this.bottom,
    this.opacity,
    this.selectorColor,
  }) : super(duration: const Duration(milliseconds: 250));

  @override
  _ItemSelectorState createState() => _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  Tween<double?>? _topY;
  Tween<double?>? _bottomY;
  Tween<double?>? _opacity;

  @override
  void forEachTween(visitor) {
    _topY = visitor(
      _topY,
      widget.top!,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double?>?;
    _bottomY = visitor(
      _bottomY,
      widget.bottom!,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double?>?;
    _opacity = visitor(
      _opacity,
      widget.opacity!,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double?>?;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topY!.evaluate(animation),
      left: widget.left,
      child: Opacity(
        opacity: _opacity!.evaluate(animation)!,
        child: Container(
          width: 5.0,
          height: _bottomY!.evaluate(animation)! - _topY!.evaluate(animation)!,
          color: widget.selectorColor,
        ),
      ),
    );
  }
}

class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final Widget? menuListItem;
  final MenuState? menuState;
  final bool? isSelected;
  final Duration duration;

  AnimatedMenuListItem({
    this.menuListItem,
    this.menuState,
    this.isSelected,
    required this.duration,
    required Curve curve,
    Key? key,
  }) : super(key: key, duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;

  _SideDrawerState? get _sideDrawerState => _SideDrawerState.of(context);

  Tween<double?>? _translation;
  Tween<double?>? _opacity;

  updateSelectedRenderBox(bool useState) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && widget.isSelected!) {
      _sideDrawerState?.setSelectedRenderBox.call(renderBox, useState);
    }
  }

  @override
  void forEachTween(visitor) {
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

      default:
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double?>?;

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double?>?;
  }

  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox(false);

    return Opacity(
      opacity: _opacity!.evaluate(animation)!,
      child: Transform(
        transform: Matrix4.translationValues(
          0.0,
          _translation!.evaluate(animation)!,
          0.0,
        ),
        child: widget.menuListItem,
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool? isSelected;
  final bool drawBorder;
  final Function()? onTap;
  final Color? selectorColor;
  final TextStyle? textStyle;
  final SideDrawer? menuView;
  final Widget? icon;
  final Widget? suffix;
  final Direction direction;
  final double? width;
  final EdgeInsets? padding;

  _MenuListItem({
    required this.title,
    this.isSelected,
    this.onTap,
    this.menuView,
    required this.textStyle,
    required this.selectorColor,
    this.icon,
    this.drawBorder = false,
    this.direction = Direction.right,
    this.width,
    this.padding,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = textStyle!
        .copyWith(color: isSelected! ? selectorColor : textStyle!.color);

    List<Widget> children = [];
    if (icon != null)
      children.add(Padding(
        padding: EdgeInsets.only(right: 16),
        child: IconTheme(
            data: IconThemeData(color: _textStyle.color), child: icon!),
      ));
    children.add(
      Expanded(
        child: Container(
          child: Text(
            title,
            style: _textStyle,
          ),
        ),
        flex: 1,
      ),
    );
    if (suffix != null)
      children.add(Padding(
        padding: EdgeInsets.only(right: 12),
        child: IconTheme(
            data: IconThemeData(color: _textStyle.color), child: suffix!),
      ));
    return InkWell(
      onTap: isSelected! ? null : onTap,
      child: Stack(
        children: [
          if (drawBorder)
            Positioned(
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                color: isSelected == true ? selectorColor! : Colors.transparent,
              ),
            ),
          Container(
            width: width,
            alignment: Alignment.centerRight,
            child: Padding(
              padding: menuView?.padding ?? EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Menu {
  final List<MenuItem> items;

  const Menu({
    required this.items,
  });
}

class MenuItem<T> {
  final T? id;
  final String title;

  /// set icon from [MenuItem], if the icon is not null, the prefix must be null
  final IconData? icon;

  /// set prefix widget from [MenuItem], if the prefix is not null, the icon must be null
  final Widget? prefix;

  /// set prefix widget from [MenuItem]
  final Widget? suffix;

  /// set independent text style for title
  final TextStyle? textStyle;

  /// append data with [MenuItem], then can be use on itemBuilder
  final dynamic data;

  MenuItem({
    this.id,
    required this.title,
    this.icon,
    this.prefix,
    this.suffix,
    this.textStyle,
    this.data,
  }) : assert(prefix == null || icon == null);

  MenuItem<T> copyWith({
    T? id,
    String? title,
    IconData? icon,
    Widget? prefix,
    Widget? suffix,
    TextStyle? textStyle,
    dynamic data,
  }) {
    return MenuItem<T>(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon,
      prefix: prefix,
      suffix: suffix,
      textStyle: textStyle ?? this.textStyle,
      data: data ?? this.data,
    );
  }
}
