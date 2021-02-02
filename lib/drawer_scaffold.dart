import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'menu_screen.dart';
import 'utils.dart';

typedef Widget DrawerScaffoldBuilder(
    BuildContext context, MenuController menuController);

/// a Scaffold wrapper
class DrawerScaffold extends StatefulWidget {
  final List<SideDrawer> drawers;
  @deprecated
  final Screen contentView;
  final ScreenBuilder builder;

  final AppBar appBar;
  final Direction mainDrawer;
  final DrawerScaffoldController controller;
  final double cornerRadius;
  final bool extendedBody;
  final bool enableGestures;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final List<BoxShadow> contentShadow;
  final Widget bottomSheet;
  final bool extendBodyBehindAppBar;
  final List<Widget> persistentFooterButtons;
  final bool primary;
  final bool resizeToAvoidBottomInset;
  final bool resizeToAvoidBottomPadding;

  /// Listen to offset value on slide event for which [SideDrawer]
  final Function(SideDrawer, double) onSlide;

  /// Listen to which [SideDrawer] is opened (offset=1)
  final Function(SideDrawer) onOpened;

  /// Listen to which [SideDrawer] is closed (offset=0)
  final Function(SideDrawer) onClosed;

  DrawerScaffold({
    this.appBar,
    this.contentShadow = const [
      BoxShadow(
        color: const Color(0x44000000),
        offset: const Offset(0.0, 5.0),
        blurRadius: 20.0,
        spreadRadius: 10.0,
      ),
    ],
    this.drawers,
    this.cornerRadius = 16.0,
    this.contentView,
    this.controller,
    this.extendedBody = false,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.builder,
    this.enableGestures = true,
    this.mainDrawer = Direction.left,
    Key key,
    this.bottomSheet,
    this.extendBodyBehindAppBar = false,
    this.persistentFooterButtons,
    this.primary = true,
    this.resizeToAvoidBottomInset,
    this.resizeToAvoidBottomPadding,
    this.onSlide,
    this.onOpened,
    this.onClosed,
  }) : super(key: key);

  @override
  _DrawerScaffoldState createState() => new _DrawerScaffoldState();

  static MenuController currentController(BuildContext context,
      {bool nullOk = true}) {
    assert(nullOk != null);
    assert(context != null);
    final _DrawerScaffoldState result =
        context.findAncestorStateOfType<_DrawerScaffoldState>();
    if (nullOk || result != null) return result._controller;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          '_SideDrawerState.of() called with a context that does not contain a MenuController.'),
      context.describeElement('The context used was')
    ]);
  }
}

class _DrawerScaffoldState<T> extends State<DrawerScaffold>
    with TickerProviderStateMixin {
  List<MenuController> menuControllers;
  // Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  // Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  // Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  // Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  Curve get scaleDownCurve => widget.drawers[focusDrawerIndex].scaleDownCurve;
  Curve get scaleUpCurve => widget.drawers[focusDrawerIndex].scaleUpCurve;
  Curve get slideOutCurve => widget.drawers[focusDrawerIndex].slideOutCurve;
  Curve get slideInCurve => widget.drawers[focusDrawerIndex].slideInCurve;

  int listenDrawerIndex = 0;
  int focusDrawerIndex = 0;

  int get mainDrawerIndex => max(
      0,
      widget.drawers
          .indexWhere((element) => element.direction == widget.mainDrawer));
  @override
  void initState() {
    super.initState();
    selectedItemId = widget.drawers[listenDrawerIndex].selectedItemId;

    assignContoller();

    updateDrawerState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    assignContoller();
    super.didUpdateWidget(oldWidget);
  }

  MenuController createController(SideDrawer d) {
    MenuController controller = dcreateController(
      context,
      d,
      this,
      (value) {
        widget.onSlide?.call(d, value);
        if (value == 0) widget.onClosed?.call(d);
        if (value == 1) widget.onOpened?.call(d);
      },
    )..addListener(() => setState(() {}));
    return controller;
  }

  MenuController dcreateController(BuildContext context, SideDrawer d,
      TickerProvider vsync, Function(double) onAnimated) {
    MenuController controller = MenuController(
      d,
      onAnimated,
      context: context,
      vsync: vsync,
    );

    return controller;
  }

  assignContoller() {
    if (menuControllers == null)
      menuControllers ??= widget.drawers.map(createController).toList();
    else
      for (var i = 0;
          i < widget.drawers.length && i < menuControllers.length;
          i++) {
        menuControllers[i]._drawer = widget.drawers[i];
      }
    for (var i = menuControllers.length; i < widget.drawers.length; i++) {
      menuControllers.add(createController(widget.drawers[i]));
    }
    if (widget.controller != null) {
      widget.controller._menuControllers = menuControllers;
      widget.controller._setFocus = (index) {
        focusDrawerIndex = index;
      };
    }
  }

  void updateDrawerState() {
    if (widget.controller != null) {
      if (widget.controller._open != null)
        menuControllers
            .firstWhere((element) =>
                element._drawer.direction == widget.controller._open)
            .open();
      else
        menuControllers.forEach((element) {
          element.close();
        });
    }
  }

  Widget createAppBar() {
    if (widget.appBar != null)
      return AppBar(
          actionsIconTheme: widget.appBar.actionsIconTheme,
          excludeHeaderSemantics: widget.appBar.excludeHeaderSemantics,
          shape: widget.appBar.shape,
          key: widget.appBar.key,
          backgroundColor: widget.appBar.backgroundColor,
          leading: widget.appBar.leading ??
              new IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    focusDrawerIndex = mainDrawerIndex;
                    menuControllers[mainDrawerIndex].toggle();
                  }),
          title: widget.appBar.title,
          automaticallyImplyLeading: widget.appBar.automaticallyImplyLeading,
          actions: widget.appBar.actions,
          flexibleSpace: widget.appBar.flexibleSpace,
          bottom: widget.appBar.bottom,
          elevation: widget.appBar.elevation,
          brightness: widget.appBar.brightness,
          iconTheme: widget.appBar.iconTheme,
          textTheme: widget.appBar.textTheme,
          primary: widget.appBar.primary,
          centerTitle: widget.appBar.centerTitle,
          titleSpacing: widget.appBar.titleSpacing,
          toolbarOpacity: widget.appBar.toolbarOpacity,
          bottomOpacity: widget.appBar.bottomOpacity);

    return null;
  }

  double startDx = 0.0;
  double percentage = 0.0;
  bool isOpening = false;

  Widget body;

  T selectedItemId;
  bool isDrawerOpen() {
    return menuControllers.where((element) => element.isOpen()).isNotEmpty;
  }

  int drawerFrom(Direction direction) {
    return menuControllers.indexWhere((element) {
      return element._drawer.direction == direction;
    });
  }

  createContentDisplay() {
    if (selectedItemId != widget.drawers[listenDrawerIndex].selectedItemId ||
        body == null) {
      selectedItemId = widget.drawers[listenDrawerIndex].selectedItemId;
      body = widget.builder?.call(context, selectedItemId) ??
          // ignore: deprecated_member_use_from_same_package
          widget.contentView?.contentBuilder(context);
    }
    Widget _scaffoldWidget = new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: createAppBar(),
      body: body,
      extendBody: widget.extendedBody,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      bottomSheet: widget.bottomSheet,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      persistentFooterButtons: widget.persistentFooterButtons,
      primary: widget.primary,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
    );

    double maxSlideAmount =
        widget.drawers[focusDrawerIndex].maxSlideAmount(context);
    Widget content = !widget.enableGestures
        ? _scaffoldWidget
        : GestureDetector(
            child: AbsorbPointer(
                absorbing: isDrawerOpen() && widget.appBar != null,
                child: _scaffoldWidget),
            onTap: () {
              menuControllers.forEach((element) {
                if (element.isOpen()) element.close();
              });
            },
            onHorizontalDragStart: (details) {
              isOpening = !isDrawerOpen();
              double width = MediaQuery.of(context).size.width;
              startDx = -1;

              if (details.globalPosition.dx < maxSlideAmount + 60) {
                int focusDrawer = drawerFrom(Direction.left);

                if (focusDrawer < 0) {
                } else {
                  this.focusDrawerIndex = focusDrawer;
                  if (isDrawerOpen()) {
                    startDx = details.globalPosition.dx;
                  } else if (details.globalPosition.dx < 60)
                    startDx = details.globalPosition.dx;
                }
              }
              if (startDx < 0 &&
                  details.globalPosition.dx > width - maxSlideAmount - 60) {
                int focusDrawer = drawerFrom(Direction.right);

                if (focusDrawer < 0) {
                  return;
                } else {
                  this.focusDrawerIndex = focusDrawer;

                  if (isDrawerOpen()) {
                    startDx = details.globalPosition.dx;
                  } else if (details.globalPosition.dx > width - 60)
                    startDx = details.globalPosition.dx;
                }
              }
            },
            onHorizontalDragUpdate: (details) {
              if (startDx == -1) return;

              double dx = (details.globalPosition.dx - startDx);
              MenuController menuController = menuControllers[focusDrawerIndex];
              if (menuController._drawer.direction == Direction.right) {
                dx = -dx;
              }
              if (isOpening && dx > 0 && dx <= maxSlideAmount) {
                percentage = Utils.fixed(dx / maxSlideAmount, 3);

                menuController._animationController
                    .animateTo(percentage, duration: Duration(microseconds: 0));
                menuController._animationController
                    .notifyStatusListeners(AnimationStatus.forward);
              } else if (!isOpening && dx <= 0 && dx >= -maxSlideAmount) {
                percentage = Utils.fixed(1.0 + dx / maxSlideAmount, 3);

                menuController._animationController
                    .animateTo(percentage, duration: Duration(microseconds: 0));
                menuController._animationController
                    .notifyStatusListeners(AnimationStatus.reverse);
              }
            },
            onHorizontalDragEnd: (details) {
              if (startDx == -1) return;
              menuControllers.forEach((menuController) {
                if (percentage < 0.5) {
                  menuController.close();
                } else {
                  menuController.open();
                }
              });
            },
          );

    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return zoomAndSlideContent(new Container(
        decoration: new BoxDecoration(
          // ignore: deprecated_member_use_from_same_package
          image: widget.contentView?.background,
          // ignore: deprecated_member_use_from_same_package
          color: widget.contentView?.color ?? Theme.of(context).canvasColor,
        ),
        child: isIOS
            ? content
            : WillPopScope(
                child: content,
                onWillPop: () {
                  return Future(() {
                    if (isDrawerOpen()) {
                      menuControllers.forEach((element) {
                        element.close();
                      });
                      return false;
                    }
                    return true;
                  });
                })));
  }

  zoomAndSlideContent(Widget content) {
    SideDrawer drawer = widget.drawers[focusDrawerIndex];
    MenuController menuController = this.menuControllers[focusDrawerIndex];
    double slidePercent = menuController._slidePercent;
    double contentScale = menuController.contentScale;
    double slideAmount = menuController.slideAmount;
    final cornerRadius = (drawer.cornerRadius ?? widget.cornerRadius) *
        menuController.percentOpen;

    double degreeAmount = (drawer.degree ?? 0) * slidePercent;
    degreeAmount = degreeAmount * pi / 180;

    Matrix4 perspective;
    if (drawer.degree == null) {
      perspective = Matrix4.translationValues(slideAmount, 0.0, 0)
        ..scale(contentScale, contentScale);
    } else {
      // perspective = _pmat(0, 1).scaled(1.0, 1.0, 1.0)
      perspective = Matrix4.identity()
        ..translate(slideAmount, 0.0, 0)
        ..scale(contentScale, contentScale)
        ..setEntry(3, 2, drawer.direction == Direction.left ? 0.001 : -0.001)
        ..rotateY(degreeAmount)
        ..rotateX(0.0)
        ..rotateZ(0.0);

      // if (drawer.direction == Direction.left) {
      //   perspective.translate(slideAmount, 0.0, 0);
      //   perspective.scale(contentScale, contentScale);
      // }
    }

    double elevation = drawer.elevation * slidePercent;
    return new Transform(
      transform: perspective,
      origin: drawer.degree != null
          ? Offset(MediaQuery.of(context).size.width / 2, 0.0)
          : drawer.direction == Direction.right
              ? Offset(MediaQuery.of(context).size.width, 0.0)
              : null,
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: elevation,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius)),
        margin: EdgeInsets.symmetric(horizontal: elevation),
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    focusDrawerIndex = min(
        widget.drawers.length - 1, focusDrawerIndex ?? widget.drawers.length);
    return Stack(
      children: [
        focusDrawerIndex >= 0 ? widget.drawers[focusDrawerIndex] : Container(),
        createContentDisplay(),
      ],
    );
  }

  MenuController get _controller => menuControllers[focusDrawerIndex];
}

class DrawerScaffoldMenuController extends StatefulWidget {
  final DrawerScaffoldBuilder builder;
  final Direction direction;
  DrawerScaffoldMenuController({
    this.builder,
    this.direction,
  });

  @override
  DrawerScaffoldMenuControllerState createState() {
    return new DrawerScaffoldMenuControllerState();
  }
}

class DrawerScaffoldMenuControllerState
    extends State<DrawerScaffoldMenuController> {
  MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = getMenuController(context, widget.direction);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (menuController != null)
      menuController.removeListener(_onMenuControllerChange);
    menuController = getMenuController(context, widget.direction);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  MenuController getMenuController(BuildContext context,
      [Direction direction = Direction.left]) {
    final scaffoldState =
        context.findAncestorStateOfType<_DrawerScaffoldState>();
    return scaffoldState.menuControllers.firstWhere(
      (element) => element._drawer.direction == direction,
      orElse: () => scaffoldState.menuControllers[0],
    );
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, getMenuController(context, widget.direction));
  }
}

typedef Widget ScreenBuilder<T>(BuildContext context, T id);

class Screen {
  final String title;
  final DecorationImage background;
  final WidgetBuilder contentBuilder;

  final Color color;

  final Color appBarColor;

  final bool enableGestures;

  Screen(
      {this.title,
      this.background,
      this.contentBuilder,
      this.color,
      this.appBarColor,
      this.enableGestures = true});
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  final Function(double) onAnimated;
  Duration duration;
  MenuState state = MenuState.closed;
  double _slidePercent = 0, _scalePercent = 0;
  double slideAmount = 0, contentScale = 0;

  SideDrawer _drawer;

  double get slidePercent => _slidePercent;
  double get scalePercent => _scalePercent;
  MenuController(this._drawer, this.onAnimated,
      {this.vsync, BuildContext context})
      : this.duration = _drawer.duration ?? const Duration(milliseconds: 250),
        _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = duration ?? const Duration(milliseconds: 250)
      ..addListener(() {
        calculate(context);

        onAnimated(_animationController.value);

        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }

        notifyListeners();
      });
    calculate(context);
  }

  calculate(BuildContext context) {
    switch (state) {
      case MenuState.closed:
        _slidePercent = 0.0;
        _scalePercent = 0.0;
        break;
      case MenuState.open:
        _slidePercent = 1.0;
        _scalePercent = 1.0;
        break;
      case MenuState.opening:
        _slidePercent = _drawer.slideOutCurve.transform(percentOpen);
        _scalePercent = _drawer.scaleDownCurve.transform(percentOpen);
        break;
      case MenuState.closing:
        _slidePercent = _drawer.slideInCurve.transform(percentOpen);
        _scalePercent = _drawer.scaleUpCurve.transform(percentOpen);
        break;
    }
    contentScale = 1.0 - ((1.0 - _drawer.percentage) * scalePercent);
    slideAmount = _drawer.maxSlideAmount(context) * slidePercent;
    if (_drawer.degree != null) {
      slideAmount = slideAmount * (1 - (1 - contentScale) / 2);
      if (_drawer.direction == Direction.right) {
        slideAmount = -slideAmount;
      }
    } else if (_drawer.direction == Direction.right) slideAmount = -slideAmount;
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  isOpen() {
    return state == MenuState.open;
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

class DrawerScaffoldController {
  List<MenuController> _menuControllers;

  ValueChanged<int> _setFocus;

  DrawerScaffoldController({Direction open}) : _open = open;

  Direction _open;
  toggle([Direction direction = Direction.left]) {
    if (isOpen())
      closeDrawer(direction);
    else
      openDrawer(direction);
  }

  openDrawer([Direction direction = Direction.left]) {
    int index = _menuControllers
        .indexWhere((element) => element._drawer.direction == direction);
    if (index >= 0) {
      _setFocus(index);
      _menuControllers[index].open();
    }
  }

  closeDrawer([Direction direction = Direction.left]) {
    _menuControllers
        .firstWhere((element) => element._drawer.direction == direction)
        .close();
  }

  ValueChanged<bool> onToggle;

  bool isOpen([Direction direction = Direction.left]) => _menuControllers
      .where((element) =>
          element._drawer.direction == direction && element.isOpen())
      .isNotEmpty;
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
