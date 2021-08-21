import 'dart:math';

import 'package:drawerbehavior/src/builder.dart';
import 'package:drawerbehavior/src/drawer_scaffold.dart';
import 'package:drawerbehavior/src/menu_item.dart';
import 'package:flutter/material.dart';

// final menuScreenKey = GlobalKey(debugLabel: 'MenuScreen');
typedef MenuItemSelected<T> = Null Function(T);
enum Direction {
  left,
  right,
}

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
    SideDrawerItemBuilder? itemBuilder,
    this.elevation = 16,
    this.cornerRadius,
    this.withSafeAre = true,
    Key? key,
    this.peekMenu = false,
    this.hideOnItemPressed = true,
  })  : assert((child != null && menu == null && itemBuilder == null) ||
            (child == null && menu != null)),
        assert(
            !peekMenu ||
                menu?.items
                        .where((element) =>
                            element.prefix == null && element.icon == null)
                        .isEmpty ==
                    true,
            "\n\nFor peek menu,\nplease provide prefix or icon in MenuItem\n"),
        this.itemBuilder = menu != null
            ? MenuSideDrawerBuilder<T>(menu, itemBuilder)
            : WidgetSideDrawerBuilder<T>(child ?? SizedBox())
                as SideDrawerBuilder,
        this.percentage = percentage ?? 0.8,
        this.degree = degree == null ? null : max(min(45, degree), 15),
        this.scaleDownCurve =
            Interval(0.0, 0.3, curve: curve ?? Curves.easeOut),
        this.scaleUpCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.slideOutCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.slideInCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.padding = padding ??
            (peekMenu
                ? const EdgeInsets.only(left: 16.0, top: 15.0, bottom: 15.0)
                : const EdgeInsets.only(left: 40.0, top: 15.0, bottom: 15.0)),
        super(key: key);

  SideDrawer.child({
    required this.child,
    this.headerView,
    this.footerView,
    this.slide = false,
    double? percentage,
    double? degree,
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
    this.elevation = 16,
    this.cornerRadius,
    this.withSafeAre = true,
    Key? key,
    this.peekMenu = false,
    this.hideOnItemPressed = true,
  })  : menu = null,
        selectedItemId = null,
        onMenuItemSelected = null,
        itemBuilder = WidgetSideDrawerBuilder(child ?? SizedBox()),
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

  SideDrawer.custom({
    required this.itemBuilder,
    this.headerView,
    this.footerView,
    this.slide = false,
    double? percentage,
    double? degree,
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
    this.elevation = 16,
    this.cornerRadius,
    this.withSafeAre = true,
    Key? key,
    this.peekMenu = false,
    this.hideOnItemPressed = true,
  })  : menu = null,
        selectedItemId = null,
        onMenuItemSelected = null,
        child = null,
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

  SideDrawer._({
    required this.itemBuilder,
    this.selectedItemId,
    this.onMenuItemSelected,
    this.headerView,
    this.footerView,
    this.slide = false,
    double? percentage,
    double? degree,
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
    this.elevation = 16,
    this.cornerRadius,
    this.withSafeAre = true,
    Key? key,
    this.peekMenu = false,
    this.hideOnItemPressed = true,
  })  : menu = null,
        child = null,
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

  static SideDrawer<int> count({
    required int itemCount,
    required SideDrawerIndexBuilder builder,
    Widget? headerView,
    Widget? footerView,
    int? selectedItemId,
    bool slide = false,
    double? percentage,
    double? degree,
    MenuItemSelected<int>? onMenuItemSelected,
    Color color = Colors.white,
    DecorationImage? background,
    bool animation = false,
    Direction direction = Direction.left,
    Color? selectorColor,
    double drawerWidth = 300,
    double peekSize = 56,
    Duration? duration,
    Curve? curve,
    TextStyle? textStyle,
    EdgeInsets? padding,
    Alignment alignment = Alignment.centerLeft,
    double elevation = 16,
    double? cornerRadius,
    bool withSafeAre = true,
    Key? key,
    bool peekMenu = false,
    bool hideOnItemPressed = true,
  }) {
    return SideDrawer<int>._(
      itemBuilder: CountSideDrawerBuilder(itemCount, builder),
      alignment: alignment,
      animation: animation,
      background: background,
      color: color,
      cornerRadius: cornerRadius,
      curve: curve,
      degree: degree,
      direction: direction,
      drawerWidth: drawerWidth,
      duration: duration,
      elevation: elevation,
      footerView: footerView,
      headerView: headerView,
      hideOnItemPressed: hideOnItemPressed,
      key: key,
      onMenuItemSelected: onMenuItemSelected,
      padding: padding,
      peekMenu: peekMenu,
      peekSize: peekSize,
      percentage: percentage,
      selectedItemId: selectedItemId,
      selectorColor: selectorColor,
      slide: slide,
      textStyle: textStyle,
      withSafeAre: withSafeAre,
    );
  }

  /// Scaling Percentage base on width and height
  final double percentage;

  /// Card's elevation
  /// Default : 16
  final double elevation;

  /// Card's corner radius
  final double? cornerRadius;

  /// Degree of rotation : 15->45 degree
  final double? degree;

  /// peekSize, default = 56
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
  final Menu<T>? menu;

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
  final MenuItemSelected<T>? onMenuItemSelected;

  /// [Widget] for header on drawer
  final Widget? headerView;

  /// [Widget] for footer on drawer
  final Widget? footerView;

  /// Custom builder for menu item
  final SideDrawerBuilder itemBuilder;

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

  double maxSlideAmount(context) => drawerWidth - (peekMenu ? peekSize : 0);

  @override
  _SideDrawerState<T> createState() => _SideDrawerState<T>();
}

class _SideDrawerState<T> extends State<SideDrawer<T>>
    with TickerProviderStateMixin {
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
    MenuController? controller =
        DrawerScaffold.getControllerFor(context, this.widget);
    controller?.value = widget.selectedItemId;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(SideDrawer<T> oldWidget) {
    if (oldWidget.selectedItemId != widget.selectedItemId) {
      MenuController? controller =
          DrawerScaffold.getControllerFor(context, this.widget);
      controller?.value = widget.selectedItemId;
    }

    super.didUpdateWidget(oldWidget);
  }

  Widget createMenuItems(MenuController? menuController) {
    widget.itemBuilder.set(widget, menuController);
    return Container(
      alignment: widget.alignment,
      margin: EdgeInsets.only(
          left: widget.direction == Direction.left
              ? 0
              : MediaQuery.of(context).size.width -
                  maxSlideAmount -
                  (widget.peekMenu ? widget.peekSize : 0)),
      child: SingleChildScrollView(
        child: Container(
          child: widget.itemBuilder.build(context),
        ),
      ),
    );
  }

  Widget createDrawer(MenuController? menuController) {
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
        builder: (context, menuController) {
          var shouldRenderSelector = true;
          var actualSelectorYTop = selectorYTop;
          var actualSelectorYBottom = selectorYBottom;
          var selectorOpacity = 1.0;

          if (menuController?.state == MenuState.closed ||
              menuController?.state == MenuState.closing ||
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

          MenuController? controller =
              DrawerScaffold.getControllerFor(context, this.widget);

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
            child: Transform.translate(
              offset: widget.direction == Direction.left || !widget.peekMenu
                  ? Offset.zero
                  : Offset(
                      (widget.drawerWidth +
                              (controller?.slideAmount ?? 0) -
                              widget.peekSize)
                          .clamp(0, widget.drawerWidth),
                      0),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      createDrawer(menuController),
                      (widget.animation && !widget.peekMenu) &&
                              shouldRenderSelector
                          ? ItemSelector(
                              right: widget.direction == Direction.right
                                  ? maxSlideAmount - 10
                                  : null,
                              selectorColor: selectorColor,
                              top: actualSelectorYTop ?? 0,
                              bottom: actualSelectorYBottom ?? 0,
                              opacity: selectorOpacity)
                          : Container(),
                    ],
                  ),
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
  final double top;
  final double bottom;
  final double? right;
  final double? opacity;

  final Color? selectorColor;

  ItemSelector({
    this.right,
    required this.top,
    required this.bottom,
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
      widget.top,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double?>?;
    _bottomY = visitor(
      _bottomY,
      widget.bottom,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double?>?;
    _opacity = visitor(
      _opacity,
      widget.opacity,
      (dynamic value) => Tween<double>(begin: value),
    ) as Tween<double?>?;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topY?.evaluate(animation),
      right: widget.right,
      child: Opacity(
        opacity: _opacity?.evaluate(animation) ?? 0,
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
