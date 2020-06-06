import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'menu_screen.dart';
import 'utils.dart';

typedef Widget DrawerScaffoldBuilder(
    BuildContext context, MenuController menuController);

class DrawerScaffold extends StatefulWidget {
  final MenuView menuView;
  @deprecated
  final Screen contentView;
  final ScreenBuilder builder;

  final AppBar appBar;
  final DrawerScaffoldController controller;
  final double percentage;
  final double cornerRadius;
  final bool extendedBody;
  final bool enableGestures;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;

  final List<BoxShadow> contentShadow;

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
    this.menuView,
    this.cornerRadius = 10.0,
    this.contentView,
    this.percentage = 0.8,
    this.controller,
    this.extendedBody,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.builder,
    this.enableGestures = true,
  });

  @override
  _DrawerScaffoldState createState() => new _DrawerScaffoldState();
}

class _DrawerScaffoldState<T> extends State<DrawerScaffold>
    with TickerProviderStateMixin {
  MenuController menuController;
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    selectedItemId = widget.menuView.selectedItemId;
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));

    updateDrawerState();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateDrawerState();
  }

  void updateDrawerState() {
    if (widget.controller != null) {
      if (widget.controller.open)
        menuController.open();
      else
        menuController.close();
      widget.controller.menuController = menuController;
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
                    menuController.toggle();
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

  createContentDisplay() {
    if (selectedItemId != widget.menuView.selectedItemId || body == null) {
      selectedItemId = widget.menuView.selectedItemId;
      body = widget.builder?.call(context, selectedItemId) ??
          widget.contentView?.contentBuilder(context);
    }
    Widget _scaffoldWidget = new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: createAppBar(),
      body: body,
      extendBody: widget.extendedBody ?? false,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
    );

    double maxSlideAmount = widget.menuView.maxSlideAmount;
    Widget content = !widget.enableGestures
        ? _scaffoldWidget
        : Center(
            child: Container(
              child: GestureDetector(
                child: AbsorbPointer(
                    absorbing: menuController.isOpen() && widget.appBar != null,
                    child: _scaffoldWidget),
                onTap: () {
                  if (menuController.isOpen()) menuController.close();
                },
                onHorizontalDragStart: (details) {
                  isOpening = !menuController.isOpen();
                  if (menuController.isOpen() &&
                      details.globalPosition.dx < maxSlideAmount + 60) {
                    startDx = details.globalPosition.dx;
                  } else if (details.globalPosition.dx < 60)
                    startDx = details.globalPosition.dx;
                  else {
                    startDx = -1;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (startDx == -1) return;
                  double dx = (details.globalPosition.dx - startDx);
                  if (isOpening && dx > 0 && dx <= maxSlideAmount) {
                    percentage = Utils.fixed(dx / maxSlideAmount, 3);

                    menuController._animationController.animateTo(percentage,
                        duration: Duration(microseconds: 0));
                    menuController._animationController
                        .notifyStatusListeners(AnimationStatus.forward);
                  } else if (!isOpening && dx <= 0 && dx >= -maxSlideAmount) {
                    percentage = Utils.fixed(1.0 + dx / maxSlideAmount, 3);

                    menuController._animationController.animateTo(percentage,
                        duration: Duration(microseconds: 0));
                    menuController._animationController
                        .notifyStatusListeners(AnimationStatus.reverse);
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (startDx == -1) return;
                  if (percentage < 0.5) {
                    menuController.close();
                  } else {
                    menuController.open();
                  }
                },
              ),
            ),
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
                    if (menuController.isOpen()) {
                      menuController.close();
                      return false;
                    }
                    return true;
                  });
                })));
  }

  zoomAndSlideContent(Widget content) {
    double maxSlideAmount = widget.menuView.maxSlideAmount;

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

    final slideAmount = maxSlideAmount * slidePercent;
    final contentScale = 1.0 - ((1.0 - widget.percentage) * scalePercent);
    final cornerRadius = widget.cornerRadius * menuController.percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
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
        widget.menuView,
        createContentDisplay(),
      ],
    );
  }
}

class DrawerScaffoldMenuController extends StatefulWidget {
  final DrawerScaffoldBuilder builder;

  DrawerScaffoldMenuController({
    this.builder,
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

    menuController = getMenuController(context);
    menuController.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    menuController.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  getMenuController(BuildContext context) {
    final scaffoldState =
        context.ancestorStateOfType(new TypeMatcher<_DrawerScaffoldState>())
            as _DrawerScaffoldState;
    return scaffoldState.menuController;
  }

  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, getMenuController(context));
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
  MenuState state = MenuState.closed;

  MenuController({
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
  MenuController menuController;

  DrawerScaffoldController({this.open = false});

  bool open;
  ValueChanged<bool> onToggle;

  bool isOpen() => menuController.isOpen();
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
