import 'dart:developer' as Dev;
import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/material.dart';

import 'menu_screen.dart';
import 'utils.dart';

typedef Widget DrawerScaffoldBuilder(
    BuildContext context, MenuController menuController);

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
    this.cornerRadius = 10.0,
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
  }) : super(key: key);

  @override
  _DrawerScaffoldState createState() => new _DrawerScaffoldState();
}

class _DrawerScaffoldState<T> extends State<DrawerScaffold>
    with TickerProviderStateMixin {
  List<MenuController> menuControllers;
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
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
    menuControllers.map((e) => e.dispose());
    super.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    assignContoller();

    super.didUpdateWidget(oldWidget);
  }

  assignContoller() {
    
    menuControllers = widget.drawers
        .map((d) => MenuController(
              d.direction,
              vsync: this,
            )..addListener(() => setState(() {})))
        .toList();
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
            .firstWhere(
                (element) => element.direction == widget.controller._open)
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
      
      return element.direction == direction;
    });
  }

  createContentDisplay() {
    if (selectedItemId != widget.drawers[listenDrawerIndex].selectedItemId ||
        body == null) {
      selectedItemId = widget.drawers[listenDrawerIndex].selectedItemId;
      body = widget.builder?.call(context, selectedItemId) ??
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

              if (menuController.direction == Direction.right) {
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

    bool isIOS = Platform.isIOS;

    return zoomAndSlideContent(new Container(
        decoration: new BoxDecoration(
          image: widget.contentView?.background,
          color: widget.contentView?.color ?? Theme.of(context).canvasColor,
        ),
        child: isIOS
            ? content
            : WillPopScope(
                child: content,
                onWillPop: () {
                  return new Future(() {
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
    double maxSlideAmount = drawer.maxSlideAmount(context);
    MenuController menuController = this.menuControllers[focusDrawerIndex];
    var slidePercent, scalePercent;
    switch (menuController.state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(menuController.percentOpen);
        scalePercent = scaleDownCurve.transform(menuController.percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(menuController.percentOpen);
        scalePercent = scaleUpCurve.transform(menuController.percentOpen);
        break;
    }

    double slideAmount = maxSlideAmount * slidePercent;
    final contentScale = 1.0 - ((1.0 - drawer.percentage) * scalePercent);
    final cornerRadius = widget.cornerRadius * menuController.percentOpen;
    

    if (widget.drawers[focusDrawerIndex].direction == Direction.right)
      slideAmount = -slideAmount + (maxSlideAmount * (1 - contentScale));
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

    return new Transform(
      transform: perspective,
      origin: drawer.direction == Direction.right
          ? Offset(MediaQuery.of(context).size.width / 2, 0.0)
          : null,
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: widget.contentShadow,
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        focusDrawerIndex != null
            ? widget.drawers[focusDrawerIndex]
            : Container(),
        createContentDisplay(),
      ],
    );
  }
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
      (element) => element.direction == direction,
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
  final Direction direction;
  MenuState state = MenuState.closed;

  MenuController(
    this.direction, {
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
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
        .indexWhere((element) => element.direction == direction);
    if (index >= 0) {
      _setFocus(index);
      _menuControllers[index].open();
    }
  }

  closeDrawer([Direction direction = Direction.left]) {
    _menuControllers
        .firstWhere((element) => element.direction == direction)
        .close();
  }

  ValueChanged<bool> onToggle;

  bool isOpen([Direction direction = Direction.left]) => _menuControllers
      .where((element) => element.direction == direction && element.isOpen())
      .isNotEmpty;
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
