import 'dart:math';
import 'package:flutter/material.dart';
import 'side_drawer.dart';
import 'package:drawerbehavior/src/utils.dart';

/// A typedef for building the content of the DrawerScaffold.
/// It provides the BuildContext and an optional MenuController.
typedef DrawerScaffoldBuilder = Widget Function(
    BuildContext context, MenuController? menuController);

/// Default function to be called when the pop gesture is invoked if no custom [onPop] is provided.
/// It simply pops the current route off the navigator.
void _defaultOnPop(BuildContext context) {
  Navigator.pop(context);
}

/// A Scaffold wrapper that provides custom drawer behavior, including
/// multiple drawers, customizable animations, and gesture control.
class DrawerScaffold extends StatefulWidget {
  /// Constructor for DrawerScaffold.
  ///
  /// [drawers]: A required list of [SideDrawer] widgets to be displayed.
  /// [appBar]: An optional [PreferredSizeWidget] to be used as the app bar for the main content.
  /// [body]: The main content widget displayed inside the scaffold.
  /// [contentShadow]: A list of [BoxShadow] applied to the main content panel when a drawer is open.
  /// [cornerRadius]: The radius for rounding the corners of the main content panel.
  /// [controller]: An optional [DrawerScaffoldController] to programmatically control the drawers.
  /// [closeOnPopInvoked]: On iOS, if true, the drawer will close when a pop event is triggered
  ///                      and the drawer is open. This also disables gesture closing.
  /// [extendedBody]: Whether the body should extend behind the bottom navigation bar and floating action button.
  /// [bottomNavigationBar]: A bottom navigation bar to display below the [body].
  /// [floatingActionButtonLocation]: The location for the [floatingActionButton].
  /// [floatingActionButton]: A floating action button.
  /// [floatingActionButtonAnimator]: An animator for the [floatingActionButton].
  /// [builder]: A builder function to dynamically create the main content widget based on the selected drawer item.
  /// [enableGestures]: Whether horizontal drag gestures are enabled to open/close drawers.
  /// [defaultDirection]: The default direction ([Direction.left] or [Direction.right]) for the main drawer.
  /// [key]: The widget's key.
  /// [bottomSheet]: A persistent bottom sheet.
  /// [extendBodyBehindAppBar]: Whether the body should extend behind the app bar.
  /// [persistentFooterButtons]: A list of buttons to display in the footer.
  /// [primary]: Whether this scaffold is the primary route.
  /// [resizeToAvoidBottomInset]: Whether the body should resize to avoid the system keyboard.
  /// [onSlide]: Callback function invoked when a drawer is sliding, providing the drawer and its offset.
  /// [onOpened]: Callback function invoked when a drawer is fully opened (offset = 1).
  /// [onClosed]: Callback function invoked when a drawer is fully closed (offset = 0).
  /// [backgroundColor]: The background color of the scaffold. Defaults to the theme's scaffold background color.
  /// [onPop]: Custom function called when a pop event is triggered. Defaults to `Navigator.pop(context)`.
  DrawerScaffold(
      {required this.drawers,
      this.appBar,
      this.body,
      this.contentShadow = const [
        BoxShadow(
          color: const Color(0x44000000),
          offset: const Offset(0.0, 5.0),
          blurRadius: 20.0,
          spreadRadius: 10.0,
        ),
      ],
      this.cornerRadius = 16.0,
      this.controller,
      this.closeOnPopInvoked = true,
      this.extendedBody = false,
      this.bottomNavigationBar,
      this.floatingActionButtonLocation,
      this.floatingActionButton,
      this.floatingActionButtonAnimator,
      this.builder,
      this.enableGestures = true,
      this.defaultDirection = Direction.left,
      Key? key,
      this.bottomSheet,
      this.extendBodyBehindAppBar = false,
      this.persistentFooterButtons,
      this.primary = true,
      this.resizeToAvoidBottomInset,
      this.onSlide,
      this.onOpened,
      this.onClosed,
      this.backgroundColor,
      this.onPop = _defaultOnPop})
      : assert((drawers.where((element) => element.peekMenu).length) < 2,
            "\n\nOnly can have one SideDrawer with peek menu\n"), // Assertion: Ensures only one SideDrawer can have a peek menu.
        assert(body == null || builder == null,
            "Use either child or builder"), // Assertion: Ensures only one of 'body' or 'builder' is provided.
        super(key: key);

  /// List of [SideDrawer] widgets to be managed by this scaffold.
  final List<SideDrawer> drawers;

  /// Optional builder function to generate the main content based on the selected menu item.
  final ScreenBuilder? builder;

  /// Optional static widget for the main content. Use either `body` or `builder`, not both.
  final Widget? body;

  /// The [AppBar] to display at the top of the main content.
  final PreferredSizeWidget? appBar;

  /// Specifies the default direction for opening the primary drawer.
  final Direction defaultDirection;

  /// Controller to programmatically open, close, and manage the drawers.
  final DrawerScaffoldController? controller;

  /// The corner radius applied to the main content panel when a drawer is open.
  final double? cornerRadius;

  /// The background color of the [DrawerScaffold].
  final Color? backgroundColor;

  /// Determines behavior on iOS when a pop gesture is invoked and a drawer is open.
  final bool closeOnPopInvoked;

  /// Whether the [body] should extend behind the [bottomNavigationBar] and [floatingActionButton].
  final bool extendedBody;

  /// Enables or disables horizontal drag gestures for opening/closing drawers.
  final bool? enableGestures;

  /// A floating action button displayed over the [body].
  final Widget? floatingActionButton;

  /// The bottom navigation bar displayed at the bottom of the scaffold.
  final Widget? bottomNavigationBar;

  /// The location of the [floatingActionButton].
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// The animator for the [floatingActionButton].
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Shadows applied to the main content panel when a drawer is open.
  final List<BoxShadow> contentShadow;

  /// A persistent bottom sheet that remains visible above the keyboard.
  final Widget? bottomSheet;

  /// Whether the [body] should extend behind the [appBar].
  final bool extendBodyBehindAppBar;

  /// A list of buttons that are always visible at the bottom of the screen.
  final List<Widget>? persistentFooterButtons;

  /// Whether this [DrawerScaffold] is the primary route.
  final bool primary;

  /// Whether the body should resize to avoid the system's bottom insets (e.g., keyboard).
  final bool? resizeToAvoidBottomInset;

  /// Callback function invoked during a drawer's slide animation.
  /// Provides the [SideDrawer] and its current `offset` (0.0 to 1.0).
  final Function(SideDrawer drawer, double offset)? onSlide;

  /// Callback function invoked when a [SideDrawer] is fully opened.
  final Function(SideDrawer drawer)? onOpened;

  /// Callback function invoked when a [SideDrawer] is fully closed.
  final Function(SideDrawer drawer)? onClosed;

  /// Custom callback executed when a pop event occurs.
  final Function(BuildContext context) onPop;

  @override
  _DrawerScaffoldState createState() => _DrawerScaffoldState();

  /// Retrieves the [MenuController] for the currently focused drawer from the nearest [DrawerScaffoldState].
  ///
  /// [context]: The build context.
  /// [nullOk]: If true, allows a null return if no controller is found; otherwise, throws an error.
  static MenuController currentController(BuildContext context,
      {bool nullOk = true}) {
    final _DrawerScaffoldState? result =
        context.findAncestorStateOfType<_DrawerScaffoldState>();
    if (nullOk || result != null) return result!._controller;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          '_SideDrawerState.of() called with a context that does not contain a MenuController.'),
      context.describeElement('The context used was')
    ]);
  }

  /// Retrieves the [MenuController] for a specific [SideDrawer] from the nearest [DrawerScaffoldState].
  ///
  /// [context]: The build context.
  /// [drawer]: The [SideDrawer] for which to get the controller.
  /// [nullOk]: If true, allows a null return if no controller is found; otherwise, throws an error.
  static MenuController? getControllerFor(
      BuildContext context, SideDrawer drawer,
      {bool nullOk = true}) {
    final _DrawerScaffoldState? result =
        context.findAncestorStateOfType<_DrawerScaffoldState>();
    if (nullOk || result != null) return result!._getControllerFor(drawer);
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          '_SideDrawerState.of() called with a context that does not contain a MenuController.'),
      context.describeElement('The context used was')
    ]);
  }
}

/// The state class for [DrawerScaffold]. It manages the drawer animations and interactions.
class _DrawerScaffoldState<T> extends State<DrawerScaffold>
    with TickerProviderStateMixin {
  // Mixin for providing ticker functionality for animations.
  /// List of [MenuController]s, one for each [SideDrawer].
  List<MenuController>? menuControllers;

  // Default animation curves for content scaling and drawer sliding.
  Curve defaultScaleDownCurve = Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve defaultScaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve defaultSlideOutCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve defaultSlideInCurve = Interval(0.0, 1.0, curve: Curves.easeOut);

  // Get the animation curves from the currently focused drawer, or use defaults.
  Curve get scaleDownCurve =>
      focusDrawer?.scaleDownCurve ?? defaultScaleDownCurve;
  Curve get scaleUpCurve => focusDrawer?.scaleUpCurve ?? defaultScaleUpCurve;
  Curve get slideOutCurve => focusDrawer?.slideOutCurve ?? defaultSlideOutCurve;
  Curve get slideInCurve => focusDrawer?.slideInCurve ?? defaultSlideInCurve;

  /// Index of the drawer currently being listened to for `onSlide` events.
  int listenDrawerIndex = 0;

  /// Index of the drawer currently in focus for transformations and interactions.
  int focusDrawerIndex = 0;

  /// Convenience getter for the currently focused [SideDrawer].
  SideDrawer? get focusDrawer => widget.drawers.getOrNull(focusDrawerIndex);

  /// Convenience getter for the currently listened [SideDrawer].
  SideDrawer? get listenDrawer => widget.drawers.getOrNull(listenDrawerIndex);

  /// Calculates the index of the main drawer based on the `defaultDirection`.
  int get mainDrawerIndex => max(
      0,
      widget.drawers.indexWhere(
          (element) => element.direction == widget.defaultDirection));
  @override
  void initState() {
    super.initState();
    // Initialize selected item ID from the listen drawer.
    selectedItemId = listenDrawer?.selectedItemId;

    // Assign and initialize menu controllers.
    assignContoller();

    // Update drawer state based on the provided controller.
    updateDrawerState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Dispose of all animation controllers to prevent memory leaks.
    menuControllers?.forEach(
      (element) {
        element._animationController.dispose();
      },
    );

    super.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    // Re-assign controllers when the widget is updated.
    assignContoller();
    super.didUpdateWidget(oldWidget as DrawerScaffold);
  }

  /// Creates and initializes a [MenuController] for a given [SideDrawer].
  MenuController createController(SideDrawer d) {
    MenuController controller = _createController(
      context,
      d,
      this, // TickerProvider
      (value) {
        // Invoke onSlide callback.
        widget.onSlide?.call(d, value);
        // Invoke onClosed or onOpened callbacks based on the animation value.
        if (value == 0) widget.onClosed?.call(d);
        if (value == 1) widget.onOpened?.call(d);
      },
    )..addListener(
        () => setState(() {})); // Rebuilds the widget on controller changes.
    return controller;
  }

  /// Calculates the total peek size from all peek menus.
  double get totalPeekSize =>
      _getPeekSize(Direction.left) + _getPeekSize(Direction.right);

  /// Gets the peek size for a drawer in a specific direction if it has a peek menu.
  double _getPeekSize(Direction direction) {
    try {
      return widget.drawers
          .firstWhere(
              (element) => element.peekMenu && direction == element.direction)
          .peekSize;
    } catch (e) {
      return 0; // Returns 0 if no peek menu found for the given direction.
    }
  }

  /// Gets the default elevation for a peek menu drawer.
  double? _getDefaultElevation() {
    try {
      return widget.drawers.firstWhere((element) => element.peekMenu).elevation;
    } catch (e) {
      return null; // Returns null if no peek menu drawer found.
    }
  }

  /// Private helper to create a [MenuController] with specific parameters.
  MenuController _createController(
    BuildContext context,
    SideDrawer d,
    TickerProvider vsync,
    Function(double) onAnimated,
  ) {
    MenuController controller = MenuController(
      d,
      onAnimated,
      context: context,
      vsync: vsync,
    );

    return controller;
  }

  /// Assigns or updates [MenuController]s based on the `drawers` list.
  /// This ensures controllers are correctly associated with drawers even after widget updates.
  assignContoller() {
    if (menuControllers == null) {
      // If controllers don't exist, create them for all drawers.
      menuControllers ??= widget.drawers.map(createController).toList();
    } else {
      // Update existing controllers' drawer references if drawers list changes.
      for (var i = 0;
          i < min(widget.drawers.length, menuControllers?.length ?? 0);
          i++) {
        menuControllers?[i]._drawer = widget.drawers[i];
      }
    }
    // Add new controllers for any newly added drawers.
    for (var i = menuControllers?.length ?? 0; i < widget.drawers.length; i++) {
      menuControllers!.add(createController(widget.drawers[i]));
    }
    // If a [DrawerScaffoldController] is provided, link it to the internal controllers.
    if (widget.controller != null) {
      widget.controller?._menuControllers = menuControllers;
      widget.controller?._setFocus = (index) {
        focusDrawerIndex = index;
      };
    }
  }

  /// Updates the drawer state based on the initial `open` direction specified in the [DrawerScaffoldController].
  void updateDrawerState() {
    if (widget.controller != null) {
      if (widget.controller?._open != null) {
        // Open the specified drawer.
        menuControllers
            ?.firstWhere((element) =>
                element._drawer.direction == widget.controller!._open)
            .open();
      } else {
        // Close all drawers if no specific 'open' direction is set.
        menuControllers?.forEach((element) {
          element.close();
        });
      }
    }
  }

  /// Creates the [AppBar] for the main content, wrapping the provided [appBar].
  /// If no `appBar` is provided, or if it's not an `AppBar` type, it handles accordingly.
  PreferredSizeWidget? createAppBar() {
    if (widget.appBar != null) {
      if (widget.appBar is AppBar) {
        final appBar = widget.appBar as AppBar;
        // Reconstructs the AppBar to inject a default leading menu icon if none is provided.
        return AppBar(
          actionsIconTheme: appBar.actionsIconTheme,
          excludeHeaderSemantics: appBar.excludeHeaderSemantics,
          shape: appBar.shape,
          key: appBar.key,
          backgroundColor: appBar.backgroundColor,
          leading: appBar
                  .leading ?? // Default leading icon for opening the main drawer.
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    focusDrawerIndex =
                        mainDrawerIndex; // Set focus to the main drawer.
                    menuControllers![mainDrawerIndex]
                        .toggle(); // Toggle the main drawer.
                  }),
          title: appBar.title,
          automaticallyImplyLeading: appBar.automaticallyImplyLeading,
          actions: appBar.actions,
          flexibleSpace: appBar.flexibleSpace,
          bottom: appBar.bottom,
          elevation: appBar.elevation,
          iconTheme: appBar.iconTheme,
          primary: appBar.primary,
          centerTitle: appBar.centerTitle,
          titleSpacing: appBar.titleSpacing,
          toolbarHeight: appBar.toolbarHeight,
          foregroundColor: appBar.foregroundColor,
          leadingWidth: appBar.leadingWidth,
          shadowColor: appBar.shadowColor,
          systemOverlayStyle: appBar.systemOverlayStyle,
          titleTextStyle: appBar.titleTextStyle,
          toolbarTextStyle: appBar.toolbarTextStyle,
          toolbarOpacity: appBar.toolbarOpacity,
          bottomOpacity: appBar.bottomOpacity,
          clipBehavior: appBar.clipBehavior,
          forceMaterialTransparency: appBar.forceMaterialTransparency,
          notificationPredicate: appBar.notificationPredicate,
          scrolledUnderElevation: appBar.scrolledUnderElevation,
          surfaceTintColor: appBar.surfaceTintColor,
        );
      } else {
        return widget
            .appBar; // Returns the custom AppBar if not an instance of AppBar.
      }
    }
    return null; // No AppBar provided.
  }

  /// Initial x-coordinate of a horizontal drag gesture.
  double startDx = 0.0;

  /// Percentage of drawer open (0.0 to 1.0) during a drag.
  double percentage = 0.0;

  /// Flag indicating if the drawer is in the process of opening via gesture.
  bool isOpening = false;

  /// The cached body widget, re-calculated only when the selected item changes.
  Widget? body;

  /// The currently selected item ID from the active drawer.
  T? selectedItemId;

  /// Checks if any drawer is currently open.
  bool isDrawerOpen() {
    return menuControllers?.where((element) => element.isOpen()).isNotEmpty ==
        true;
  }

  /// Finds the index of a drawer based on its [Direction].
  int drawerFrom(Direction direction) {
    return menuControllers?.indexWhere((element) {
          return element._drawer.direction == direction;
        }) ??
        -1; // Returns -1 if no drawer is found for the given direction.
  }

  /// Creates the main content display, including the Scaffold and gesture detection.
  createContentDisplay() {
    final drawer = listenDrawer;
    // Update the body only if the selected item has changed or if it's null.
    if (selectedItemId != drawer?.selectedItemId || body == null) {
      selectedItemId = drawer?.selectedItemId;
      body = widget.body ?? widget.builder?.call(context, selectedItemId);
    }
    // The main Scaffold that holds the app bar and body.
    Widget _scaffoldWidget = Container(
      width: MediaQuery.of(context).size.width -
          totalPeekSize, // Adjusts width for peek menus.
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Background transparent for drawer effect.
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
      ),
    );

    // Get the maximum slide amount for the focused drawer.
    double maxSlideAmount = focusDrawer?.maxSlideAmount(context) ?? 0;
    // Wrap the Scaffold with GestureDetector for horizontal drag handling.
    Widget content = !widget.enableGestures!
        ? _scaffoldWidget // If gestures are disabled, just return the scaffold.
        : GestureDetector(
            child: AbsorbPointer(
                absorbing: isDrawerOpen() &&
                    widget.appBar !=
                        null, // Absorb pointer events on content if drawer is open and app bar is present.
                child: _scaffoldWidget),
            onTap: () {
              // Close any open drawers when tapping the content.
              menuControllers?.forEach((element) {
                if (element.isOpen()) element.close();
              });
            },
            onHorizontalDragStart: (details) {
              // Initialize drag state.
              isOpening = !isDrawerOpen();
              double width = MediaQuery.of(context).size.width;
              startDx = -1; // -1 indicates no valid drag started.

              // Check for drag from left edge.
              if (details.globalPosition.dx < maxSlideAmount + 60) {
                int focusDrawer = drawerFrom(Direction.left);

                if (focusDrawer >= 0) {
                  // If a left drawer exists.
                  this.focusDrawerIndex = focusDrawer;
                  if (isDrawerOpen()) {
                    startDx = details.globalPosition
                        .dx; // Start from current position if already open.
                  } else if (details.globalPosition.dx < 60) {
                    // Start drag if within 60px of left edge.
                    startDx = details.globalPosition.dx;
                  }
                }
              }
              // Check for drag from right edge.
              if (startDx < 0 &&
                  details.globalPosition.dx > width - maxSlideAmount - 60) {
                int focusDrawer = drawerFrom(Direction.right);

                if (focusDrawer >= 0) {
                  // If a right drawer exists.
                  this.focusDrawerIndex = focusDrawer;

                  if (isDrawerOpen()) {
                    startDx = details.globalPosition
                        .dx; // Start from current position if already open.
                  } else if (details.globalPosition.dx > width - 60) {
                    // Start drag if within 60px of right edge.
                    startDx = details.globalPosition.dx;
                  }
                }
              }
            },
            onHorizontalDragUpdate: (details) {
              if (startDx == -1) return; // Ignore if drag didn't start validly.

              double dx = (details.globalPosition.dx - startDx);
              MenuController menuController =
                  menuControllers![focusDrawerIndex];
              // Adjust dx for right-side drawers.
              if (menuController._drawer.direction == Direction.right) {
                dx = -dx;
              }
              // Update percentage and animation based on drag direction (opening/closing).
              if (isOpening && dx > 0 && dx <= maxSlideAmount) {
                percentage = Utils.fixed(dx / maxSlideAmount, 3);
                menuController
                  .._animationController.animateBack(percentage,
                      duration: Duration(
                          microseconds:
                              0)) // Animate directly to the dragged percentage.
                  ..state = MenuState.opening;
              } else if (!isOpening && dx <= 0 && dx >= -maxSlideAmount) {
                percentage = Utils.fixed(1.0 + dx / maxSlideAmount, 3);
                menuController
                  .._animationController.animateBack(percentage,
                      duration: Duration(microseconds: 0))
                  ..state = MenuState.closing;
              }
            },
            onHorizontalDragEnd: (details) {
              if (startDx == -1) return; // Ignore if drag didn't start validly.
              // Based on the final drag percentage, either open or close the drawer.
              menuControllers?.forEach((menuController) {
                if (percentage < 0.5) {
                  menuController.close();
                } else {
                  menuController.open();
                }
              });
            },
          );

    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Apply zoom and slide transformations to the content.
    return zoomAndSlideContent(
      Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ??
              Theme.of(context)
                  .scaffoldBackgroundColor, // Set background color.
        ),
        child: isIOS && !widget.closeOnPopInvoked
            ? content // On iOS, if closeOnPopInvoked is false, don't use PopScope.
            : PopScope(
                // PopScope handles back button/gesture behavior.
                child: content,
                canPop: false, // Prevents default pop behavior.
                onPopInvokedWithResult: (didPop, result) async {
                  if (didPop) {
                    return; // If platform already popped, do nothing.
                  }
                  if (isDrawerOpen()) {
                    // If drawer is open, close it on pop.
                    menuControllers?.forEach((element) {
                      element.close();
                    });
                    return;
                  } else {
                    widget.onPop(
                        context); // Otherwise, invoke the custom onPop callback.
                  }
                },
              ),
      ),
    );
  }

  /// Applies zoom, slide, rotation, and corner radius transformations to a widget (content or drawer).
  zoomAndSlideContent(Widget content, [bool isDrawer = false]) {
    MenuController menuController = this.menuControllers![focusDrawerIndex];

    SideDrawer? drawer = focusDrawer;

    if (drawer == null)
      return content; // If no drawer is focused, return content as is.

    double slidePercent = menuController._slidePercent;
    double contentScale = menuController.contentScale;
    double slideAmount = menuController.slideAmount;
    // Calculate corner radius based on the drawer's open percentage.
    final cornerRadius = (drawer.cornerRadius ?? widget.cornerRadius)! *
        menuController.percentOpen;

    // Calculate rotation degree.
    double degreeAmount = (drawer.degree ?? 0) * slidePercent;
    degreeAmount = degreeAmount * pi / 180; // Convert degrees to radians.

    Matrix4 perspective;
    if (drawer.degree == null) {
      // Standard slide and scale transformation.
      perspective = Matrix4.translationValues(slideAmount, 0.0, 0)
        ..scale(contentScale, contentScale);
    } else {
      // Perspective transformation with rotation.
      perspective = Matrix4.identity()
        ..translate(slideAmount, 0.0, 0)
        ..scale(contentScale, contentScale)
        ..setEntry(3, 2,
            drawer.direction == Direction.left ? 0.001 : -0.001) // Adds depth.
        ..rotateY(degreeAmount) // Rotate around Y-axis.
        ..rotateX(0.0)
        ..rotateZ(0.0);
    }

    final defaultElavation = _getDefaultElevation();
    // Calculate elevation based on drawer state.
    double elevation = defaultElavation ?? drawer.elevation * slidePercent;
    return Transform(
      transform: perspective,
      // Set the origin for rotation or scaling.
      origin: drawer.degree != null
          ? Offset(MediaQuery.of(context).size.width / 2,
              0.0) // Center origin for degree animation.
          : drawer.direction == Direction.right
              ? Offset(
                  MediaQuery.of(context).size.width -
                      drawer.elevation -
                      totalPeekSize,
                  0.0) // Right side origin for standard slide.
              : null, // Left side origin.
      alignment: Alignment.centerLeft, // Alignment for transformations.
      child: Card(
        margin: isDrawer
            ? EdgeInsets.zero // No margin for the drawer itself.
            : defaultElavation == null
                ? EdgeInsets.symmetric(
                    horizontal:
                        elevation) // Margin based on elevation if no default.
                : EdgeInsets.fromLTRB(
                    _getPeekSize(Direction.left),
                    0,
                    _getPeekSize(Direction.right),
                    0), // Margins for peek menus.
        elevation: elevation, // Apply elevation.
        clipBehavior:
            Clip.antiAliasWithSaveLayer, // Clip content to rounded corners.
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(cornerRadius)), // Apply rounded corners.
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure focusDrawerIndex is within bounds.
    focusDrawerIndex = min((widget.drawers.length) - 1, focusDrawerIndex);

    // Build the UI using a Stack to layer drawers and content.
    return Stack(
      children: [
        // Renders the focused drawer (either left or right).
        focusDrawerIndex >= 0 ? focusDrawer ?? SizedBox() : SizedBox(),

        // Renders other drawers that have a peek menu, but are not currently focused.
        for (var i = 0; i < widget.drawers.length; i++)
          if (widget.drawers[i].peekMenu && i != focusDrawerIndex)
            zoomAndSlideContent(widget.drawers[i],
                true), // Apply transformations to peek menus.

        // Renders the main content with its transformations.
        createContentDisplay(),
      ],
    );
  }

  /// Private getter for the [MenuController] of the currently focused drawer.
  MenuController get _controller => menuControllers![focusDrawerIndex];

  /// Private method to get the [MenuController] for a specific [SideDrawer].
  MenuController? _getControllerFor(SideDrawer drawer) {
    final index = widget.drawers.indexOf(drawer);
    if (index >= 0) return menuControllers?[index];
    return null;
  }
}

/// A widget that provides access to the [MenuController] from within the widget tree.
/// This allows child widgets to control the drawer.
class DrawerScaffoldMenuController extends StatefulWidget {
  /// Builder function to create the widget's content, receiving the [MenuController].
  final DrawerScaffoldBuilder? builder;

  /// The direction of the drawer this controller should target.
  final Direction? direction;
  DrawerScaffoldMenuController({
    this.builder,
    this.direction,
  });

  @override
  DrawerScaffoldMenuControllerState createState() {
    return DrawerScaffoldMenuControllerState();
  }
}

/// The state for [DrawerScaffoldMenuController].
class DrawerScaffoldMenuControllerState
    extends State<DrawerScaffoldMenuController> {
  /// The [MenuController] instance for the targeted drawer.
  MenuController? menuController;

  @override
  void initState() {
    super.initState();

    // Get the MenuController and add a listener to rebuild on changes.
    menuController = getMenuController(context, widget.direction);
    menuController?.addListener(_onMenuControllerChange);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget as DrawerScaffoldMenuController);
    // Remove listener from old controller and add to new one if widget updates.
    if (menuController != null) {
      menuController?.removeListener(_onMenuControllerChange);
    }
    menuController = getMenuController(context, widget.direction);
    menuController?.addListener(_onMenuControllerChange);
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks.
    menuController?.removeListener(_onMenuControllerChange);
    super.dispose();
  }

  /// Retrieves the [MenuController] for a specific drawer direction from the `_DrawerScaffoldState`.
  MenuController? getMenuController(BuildContext context,
      [Direction? direction = Direction.left]) {
    final scaffoldState =
        context.findAncestorStateOfType<_DrawerScaffoldState>()!;
    try {
      return scaffoldState.menuControllers?.firstWhere(
        (element) => element._drawer.direction == direction,
      );
    } catch (e) {
      return null;
    }
  }

  /// Callback to trigger a rebuild when the `menuController` notifies listeners.
  _onMenuControllerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget using the provided builder and the retrieved menu controller.
    return widget.builder
            ?.call(context, getMenuController(context, widget.direction)) ??
        SizedBox(); // Return an empty SizedBox if no builder is provided.
  }
}

/// A typedef for a builder function that creates a widget based on a selected item ID.
typedef Widget ScreenBuilder<T>(BuildContext context, T? id);

/// Represents a "screen" or content item that can be selected from a drawer.
class Screen {
  /// The title of the screen.
  final String? title;

  /// An optional background image for the screen.
  final DecorationImage? background;

  /// A builder function to create the content of the screen.
  final WidgetBuilder? contentBuilder;

  /// The background color of the screen.
  final Color? color;

  /// The background color of the app bar specific to this screen.
  final Color? appBarColor;

  /// Whether gestures are enabled for this specific screen.
  final bool enableGestures;

  /// Constructor for a [Screen].
  Screen(
      {this.title,
      this.background,
      this.contentBuilder,
      this.color,
      this.appBarColor,
      this.enableGestures = true});
}

/// Controls the animation and state of a single [SideDrawer].
class MenuController extends ChangeNotifier {
  /// The TickerProvider for the animation controller.
  final TickerProvider vsync;

  /// The underlying animation controller.
  final AnimationController _animationController;

  /// Callback function invoked when the animation value changes.
  final Function(double) onAnimated;

  /// The currently selected value or item ID associated with this drawer.
  dynamic _value;

  /// Getter for the selected value.
  dynamic get value => _value;

  /// Setter for the selected value, automatically calling `updateValue`.
  set value(dynamic value) {
    this._value = value;
  }

  /// Updates the selected value and notifies listeners.
  updateValue(dynamic value) {
    this._value = value;
    notifyListeners();
  }

  /// The duration of the drawer animation.
  Duration duration;

  /// The current state of the menu (closed, opening, open, closing).
  MenuState state = MenuState.closed;

  /// Current slide percentage (0.0 to 1.0).
  double _slidePercent = 0, _scalePercent = 0;

  /// Calculated slide amount in pixels.
  double slideAmount = 0, contentScale = 0;

  /// The [SideDrawer] associated with this controller.
  SideDrawer _drawer;

  /// Getter for the current slide percentage.
  double get slidePercent => _slidePercent;

  /// Getter for the current scale percentage.
  double get scalePercent => _scalePercent;

  /// Constructor for [MenuController].
  MenuController(this._drawer, this.onAnimated,
      {required this.vsync, BuildContext? context})
      : this.duration = _drawer.duration ??
            const Duration(
                milliseconds: 250), // Use drawer's duration or default.
        _animationController = AnimationController(vsync: vsync) {
    _animationController
      ..duration = duration // Set animation duration.
      ..addListener(() {
        // Recalculate transformations on every animation tick.
        calculate(context);

        // Invoke the onAnimated callback.
        onAnimated(_animationController.value);

        // Notify listeners to rebuild the UI.
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        // Update the menu state based on animation status.
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

        notifyListeners(); // Notify listeners of state change.
      });
    calculate(context); // Initial calculation of transformations.
  }

  /// Calculates the `slideAmount` and `contentScale` based on the current animation state.
  calculate(BuildContext? context) {
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
        // Apply opening curves.
        _slidePercent = _drawer.slideOutCurve.transform(percentOpen);
        _scalePercent = _drawer.scaleDownCurve.transform(percentOpen);
        break;
      case MenuState.closing:
        // Apply closing curves.
        _slidePercent = _drawer.slideInCurve.transform(percentOpen);
        _scalePercent = _drawer.scaleUpCurve.transform(percentOpen);
        break;
    }
    // Calculate content scale based on drawer's percentage and scale percentage.
    contentScale = 1.0 - ((1.0 - _drawer.percentage) * scalePercent);
    // Calculate slide amount based on max slide, elevation, and slide percentage.
    slideAmount = (_drawer.maxSlideAmount(context) - _drawer.elevation - 2) *
        slidePercent;
    // Adjust slide amount for degree animations or right-side drawers.
    if (_drawer.degree != null) {
      slideAmount = slideAmount * (1 - (1 - contentScale) / 2);
      if (_drawer.direction == Direction.right) {
        slideAmount = -slideAmount;
      }
    } else if (_drawer.direction == Direction.right) {
      slideAmount = -slideAmount;
    }
  }

  @override
  dispose() {
    _animationController.dispose(); // Dispose of the animation controller.
    super.dispose();
  }

  /// Returns the current value of the animation controller, representing the open percentage.
  get percentOpen {
    return _animationController.value;
  }

  /// Initiates the animation to open the drawer.
  Future<void> open() => _animationController.forward();

  /// Initiates the animation to close the drawer.
  Future<void> close() => _animationController.reverse();

  /// Checks if the drawer is fully open.
  isOpen() {
    return state == MenuState.open;
  }

  /// Toggles the drawer state (opens if closed, closes if open).
  Future<void> toggle() async {
    if (state == MenuState.open) {
      return close();
    } else if (state == MenuState.closed) {
      return open();
    }
  }
}

/// A controller class to programmatically manage the state of drawers in [DrawerScaffold].
class DrawerScaffoldController {
  /// Internal list of [MenuController]s managed by the [DrawerScaffoldState].
  List<MenuController>? _menuControllers;

  /// Callback to set the focus on a specific drawer by its index.
  late ValueChanged<int> _setFocus;

  /// Constructor for [DrawerScaffoldController].
  /// [open]: An optional direction to open a drawer initially.
  DrawerScaffoldController({Direction? open}) : _open = open;

  /// The initial direction to open a drawer.
  Direction? _open;

  /// Toggles the specified drawer (opens if closed, closes if open).
  Future<void> toggle([Direction direction = Direction.left]) {
    if (isOpen(direction)) {
      return closeDrawer(direction);
    } else {
      return openDrawer(direction);
    }
  }

  /// Opens the drawer in the specified direction.
  Future<void> openDrawer([Direction direction = Direction.left]) async {
    int index = _menuControllers!
        .indexWhere((element) => element._drawer.direction == direction);
    if (index >= 0) {
      _setFocus(index); // Set focus to the drawer being opened.
      return _menuControllers![index].open();
    }
  }

  /// Closes the drawer in the specified direction.
  Future<void> closeDrawer([Direction direction = Direction.left]) {
    return _menuControllers!
        .firstWhere((element) => element._drawer.direction == direction)
        .close();
  }

  /// Callback triggered when a drawer is toggled.
  ValueChanged<bool>? onToggle;

  /// Checks if the drawer in the specified direction is open.
  bool isOpen([Direction direction = Direction.left]) =>
      _menuControllers
          ?.where((element) =>
              element._drawer.direction == direction && element.isOpen())
          .isNotEmpty ==
      true;
}

/// Enum representing the possible states of a menu (drawer).
enum MenuState {
  closed, // Menu is fully closed.
  opening, // Menu is in the process of opening.
  open, // Menu is fully open.
  closing, // Menu is in the process of closing.
}
