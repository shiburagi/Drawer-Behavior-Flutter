import 'dart:math';

import 'package:drawerbehavior/src/builder.dart';
import 'package:drawerbehavior/src/drawer_scaffold.dart';
import 'package:drawerbehavior/src/menu_item.dart';
import 'package:flutter/material.dart' hide MenuController;

// final menuScreenKey = GlobalKey(debugLabel: 'MenuScreen'); // A commented-out GlobalKey, possibly for debugging or an alternative way to access state.

/// A typedef for a callback function when a menu item is selected, returning the selected item's ID.
typedef MenuItemSelected<T> = Null Function(T);

/// Enum to define the direction from which a drawer can appear.
enum Direction {
  left, // Drawer slides from the left.
  right, // Drawer slides from the right.
}

/// A customizable side drawer widget that can be used with `DrawerScaffold`.
///
/// It supports various configurations including menu items, custom children,
/// animation effects, and appearance customizations.
class SideDrawer<T> extends StatefulWidget {
  /// Default constructor for `SideDrawer` using a [Menu] or custom [child]/[itemBuilder].
  ///
  /// [menu]: The list of menu items to display.
  /// [headerView]: An optional widget to display at the top of the drawer.
  /// [footerView]: An optional widget to display at the bottom of the drawer.
  /// [selectedItemId]: The ID of the currently selected menu item.
  /// [slide]: If true, the main content will slide along with the drawer.
  /// [percentage]: The scaling percentage for the main content when the drawer is open.
  /// [degree]: The degree of rotation for the main content when the drawer is open (15-45 degrees).
  /// [onMenuItemSelected]: Callback when a menu item is selected.
  /// [child]: A single widget to use as the drawer's content (alternative to [menu]).
  /// [color]: Background color of the drawer.
  /// [background]: A background image for the drawer.
  /// [animation]: Enables/disables animation on menu items.
  /// [direction]: The direction from which the drawer will appear.
  /// [selectorColor]: Color of the indicator for the selected menu item.
  /// [drawerWidth]: The fixed width of the drawer in pixels.
  /// [peekSize]: The width of the "peek" area when the drawer is in peek mode.
  /// [duration]: The animation duration for opening/closing the drawer.
  /// [curve]: The animation curve for various transformations.
  /// [textStyle]: Default text style for menu items.
  /// [padding]: Padding for the menu items.
  /// [alignment]: Alignment of menu items within the drawer.
  /// [itemBuilder]: Custom builder for rendering individual menu items.
  /// [elevation]: The elevation (shadow) of the drawer.
  /// [cornerRadius]: The corner radius of the drawer.
  /// [withSafeAre]: Whether to wrap header and footer views in `SafeArea`.
  /// [peekMenu]: If true, the drawer remains partially visible.
  /// [hideOnItemPressed]: If true, the drawer closes when a menu item is pressed.
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
  })  : // Assertions to ensure valid combinations of `child`, `menu`, and `itemBuilder`.
        assert((child != null && menu == null && itemBuilder == null) ||
            (child == null && menu != null)),
        // Assertion for peek menu: items must have prefix or icon.
        assert(
            !peekMenu ||
                menu?.items
                        .where((element) =>
                            element.prefix == null && element.icon == null)
                        .isEmpty ==
                    true,
            "\n\nFor peek menu,\nplease provide prefix or icon in MenuItem\n"),
        // Initialize itemBuilder based on whether a menu or child is provided.
        this.itemBuilder = menu != null
            ? MenuSideDrawerBuilder<T>(menu, itemBuilder)
            : WidgetSideDrawerBuilder<T>(child ?? SizedBox())
                as SideDrawerBuilder,
        this.percentage =
            percentage ?? 0.8, // Default content scaling percentage.
        this.degree = degree == null
            ? null
            : max(min(45, degree), 15), // Clamp degree to a valid range.
        // Define animation curves for various transitions.
        this.scaleDownCurve =
            Interval(0.0, 0.3, curve: curve ?? Curves.easeOut),
        this.scaleUpCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.slideOutCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.slideInCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        // Set default padding based on whether it's a peek menu.
        this.padding = padding ??
            (peekMenu
                ? const EdgeInsets.only(left: 16.0, top: 15.0, bottom: 15.0)
                : const EdgeInsets.only(left: 40.0, top: 15.0, bottom: 15.0)),
        super(key: key);

  /// Constructor for creating a `SideDrawer` with a custom child widget.
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
  })  : menu = null, // No menu items for a child-based drawer.
        selectedItemId = null, // No selected item ID as there's no menu.
        onMenuItemSelected = null, // No menu item selection callback.
        itemBuilder = WidgetSideDrawerBuilder(
            child ?? SizedBox()), // Use WidgetSideDrawerBuilder for the child.
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

  /// Constructor for creating a `SideDrawer` with a fully custom item builder.
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
  })  : menu = null, // No default menu provided.
        selectedItemId = null, // No selected item ID as it's fully custom.
        onMenuItemSelected = null, // No default menu item selection callback.
        child = null, // No default child widget.
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

  /// Private constructor used by factory methods to create a `SideDrawer` with a pre-defined [itemBuilder].
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
            Interval(0.0, 0.3, curve: curve ?? Curves.easeOut),
        this.scaleUpCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.slideOutCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.slideInCurve = Interval(0.0, 1.0, curve: curve ?? Curves.easeOut),
        this.padding = padding ??
            (peekMenu
                ? const EdgeInsets.only(left: 16.0, top: 15.0, bottom: 15.0)
                : const EdgeInsets.only(left: 40.0, top: 15.0, bottom: 15.0)),
        super(key: key);

  /// Factory constructor to create a `SideDrawer` that builds items based on an item count and a builder function.
  static SideDrawer<int> count({
    required int itemCount, // Total number of items to build.
    required SideDrawerIndexBuilder
        builder, // Builder function to create a widget for each index.
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
      itemBuilder: CountSideDrawerBuilder(
          itemCount, builder), // Uses CountSideDrawerBuilder.
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

  /// The scaling percentage for the main content when the drawer is open.
  final double percentage;

  /// The elevation (shadow) of the drawer card.
  /// Default: 16
  final double elevation;

  /// The corner radius applied to the drawer card.
  final double? cornerRadius;

  /// The degree of rotation for the main content. Clamped between 15 and 45 degrees.
  final double? degree;

  /// The width of the partially visible menu when `peekMenu` is true.
  /// Default: 56
  final double peekSize;

  /// The fixed width of the drawer in pixels.
  /// Default: 300px
  final double drawerWidth;

  /// The direction from which the drawer will appear (left or right).
  /// Default: [Direction.left]
  final Direction direction;

  /// The animation [Curve] used for transitions.
  /// Default: [Curves.easeOut]
  final Curve? curve;

  /// The [Duration] of the drawer's open/close animation.
  /// Default: 250ms
  final Duration? duration;

  /// The [Menu] object containing items to display in the drawer.
  final Menu<T>? menu;

  /// The currently selected item's ID.
  final T? selectedItemId;

  /// Whether to apply animation effects to menu items.
  final bool animation;

  /// If true, the drawer will remain partially visible on the side.
  final bool peekMenu;

  /// If true, the drawer will automatically close when a menu item is pressed.
  /// Default: true
  final bool hideOnItemPressed;

  /// If true, the main content slides along with the drawer opening/closing.
  final bool slide;

  /// Callback function invoked when a menu item is selected.
  final MenuItemSelected<T>? onMenuItemSelected;

  /// The widget to display at the top of the drawer.
  final Widget? headerView;

  /// The widget to display at the bottom of the drawer.
  final Widget? footerView;

  /// The custom builder responsible for rendering the drawer's content/items.
  final SideDrawerBuilder itemBuilder;

  /// A single child widget to display as the drawer's content.
  final Widget? child;

  /// An optional background image for the drawer.
  final DecorationImage? background;

  /// The background [Color] of the drawer.
  final Color color;

  /// The [Color] of the visual indicator for the selected menu item.
  final Color? selectorColor;

  /// The default [TextStyle] for menu item text.
  final TextStyle? textStyle;

  /// The [Alignment] of the menu content within the drawer.
  final Alignment alignment;

  /// The [Padding] applied to the menu content within the drawer.
  final EdgeInsets padding;

  /// The easing [Curve] for scaling down the main content.
  final Curve scaleDownCurve;

  /// The easing [Curve] for scaling up the main content.
  final Curve scaleUpCurve;

  /// The easing [Curve] for the drawer sliding out.
  final Curve slideOutCurve;

  /// The easing [Curve] for the drawer sliding in.
  final Curve slideInCurve;

  /// Whether to include [SafeArea] for the `headerView` and `footerView`.
  /// Default: true
  final bool withSafeAre;

  /// Calculates the maximum amount the drawer can slide based on its width and peek size.
  double maxSlideAmount(context) => drawerWidth - (peekMenu ? peekSize : 0);

  @override
  _SideDrawerState<T> createState() => _SideDrawerState<T>();
}

/// The state class for `SideDrawer`, managing its internal UI properties and interactions.
class _SideDrawerState<T> extends State<SideDrawer<T>> {
  double? selectorYTop; // Top Y-coordinate of the selected item indicator.
  double?
      selectorYBottom; // Bottom Y-coordinate of the selected item indicator.

  Color? selectorColor; // Color of the selected item indicator.
  TextStyle? textStyle; // Text style for menu items.

  /// Convenience getter for the maximum slide amount.
  double get maxSlideAmount => widget.maxSlideAmount(context);

  /// Sets the position of the selected menu item indicator.
  ///
  /// [newRenderBox]: The RenderBox of the newly selected menu item.
  /// [useState]: If true, calls `setState` to update the UI immediately.
  setSelectedRenderBox(RenderBox newRenderBox, bool useState) async {
    final renderBox = context.findRenderObject()
        as RenderBox?; // Get the RenderBox of this drawer.

    final newYTop = newRenderBox
        .localToGlobal(Offset(0.0, 0.0), ancestor: renderBox)
        .dy; // Calculate global top Y.

    final newYBottom =
        newYTop + newRenderBox.size.height; // Calculate global bottom Y.
    if (newYTop != selectorYTop) {
      // Only update if position has actually changed.
      selectorYTop = newYTop;
      selectorYBottom = newYBottom;
    }
  }

  @override
  void initState() {
    super.initState();
    // Get the MenuController for this specific drawer and set its initial value.
    MenuController? controller =
        DrawerScaffold.getControllerFor(context, this.widget);
    controller?.value = widget.selectedItemId;
  }

  @override
  void didUpdateWidget(SideDrawer<T> oldWidget) {
    // If the selected item ID changes, update the MenuController's value.
    if (oldWidget.selectedItemId != widget.selectedItemId) {
      MenuController? controller =
          DrawerScaffold.getControllerFor(context, this.widget);
      controller?.value = widget.selectedItemId;
    }

    super.didUpdateWidget(oldWidget);
  }

  /// Creates the scrollable list of menu items.
  Widget createMenuItems(MenuController? menuController) {
    widget.itemBuilder.set(
        widget, menuController); // Pass widget and controller to the builder.
    return Container(
      alignment: widget.alignment, // Align items within the drawer.
      margin: EdgeInsets.only(
          left: widget.direction == Direction.left
              ? 0
              : MediaQuery.of(context)
                      .size
                      .width - // Adjust margin for right-side drawers.
                  maxSlideAmount -
                  (widget.peekMenu ? widget.peekSize : 0)),
      child: SingleChildScrollView(
        // Allows content to scroll if it overflows.
        child: Container(
          child:
              widget.itemBuilder.build(context), // Build the actual menu items.
        ),
      ),
    );
  }

  /// Creates the entire drawer structure, including header, menu items, and footer.
  Widget createDrawer(MenuController? menuController) {
    List<Widget> widgets = [];
    if (widget.headerView != null) {
      widgets.add(Container(
        alignment: widget.alignment,
        margin: EdgeInsets.only(
            left: widget.direction == Direction.left
                ? 0
                : MediaQuery.of(context).size.width - maxSlideAmount),
        child: Container(
            width: maxSlideAmount,
            child: widget.headerView), // Constrain header width.
      ));
    } else {}
    widgets.add(Expanded(
      // Menu items take up available space.
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
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .padding
                    .bottom), // Respect system insets.
          )));
    }
    // Get the global MenuController to apply slide transformations.
    MenuController controller = DrawerScaffold.currentController(context);
    return Transform(
      transform: Matrix4.translationValues(
        widget.slide // Apply slide effect if enabled.
            ? (widget.direction == Direction.left ? 1 : -1) *
                (widget.maxSlideAmount(context)) *
                (controller.slidePercent -
                    1) // Calculate translation based on slide percentage.
            : 0,
        0,
        0.0,
      ),
      child: Opacity(
        opacity: controller.slidePercent == 0
            ? 0
            : 1, // Make drawer transparent when fully closed.
        child: SafeArea(
          // Apply SafeArea if specified.
          top: widget.withSafeAre || widget.headerView == null,
          bottom: widget.withSafeAre || widget.footerView == null,
          child: Container(
            height: MediaQuery.of(context)
                .size
                .height, // Drawer takes full screen height.
            child: Column(
              // Arrange header, menu, and footer vertically.
              children: widgets,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize selector and text styles, falling back to theme defaults.
    selectorColor = widget.selectorColor ?? Theme.of(context).indicatorColor;
    textStyle = widget.textStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
            color: widget.color.computeLuminance() <
                    0.5 // Adjust text color for contrast.
                ? Colors.white
                : Colors.black);
    // Use DrawerScaffoldMenuController to get access to the specific MenuController for this drawer.
    return DrawerScaffoldMenuController(
        direction: widget.direction,
        builder: (context, menuController) {
          var shouldRenderSelector = true;
          var actualSelectorYTop = selectorYTop;
          var actualSelectorYBottom = selectorYBottom;
          var selectorOpacity = 1.0;

          // Logic to handle selector visibility and position when drawer is closed/closing.
          if (menuController?.state == MenuState.closed ||
              menuController?.state == MenuState.closing ||
              selectorYTop == null) {
            final RenderBox? menuScreenRenderBox =
                context.findRenderObject() as RenderBox?;

            if (menuScreenRenderBox != null) {
              final menuScreenHeight = menuScreenRenderBox.size.height;
              actualSelectorYTop =
                  menuScreenHeight - 50.0; // Position off-screen or at bottom.
              actualSelectorYBottom = menuScreenHeight;
              selectorOpacity = 0.0; // Hide selector.
            } else {
              shouldRenderSelector =
                  false; // Don't render if RenderBox is not found.
            }
          }

          MenuController? controller =
              DrawerScaffold.getControllerFor(context, this.widget);

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: widget.background, // Apply background image if present.
              color: widget.color, // Apply background color.
            ),
            child: Transform.translate(
              // Apply translation for peek menu effect if it's a right-side drawer.
              offset: widget.direction == Direction.left || !widget.peekMenu
                  ? Offset.zero
                  : Offset(
                      (widget.drawerWidth +
                              (controller?.slideAmount ?? 0) -
                              widget.peekSize)
                          .clamp(0, widget.drawerWidth), // Clamp translation.
                      0),
              child: Center(
                child: Material(
                  color: Colors
                      .transparent, // Transparent material for background.
                  child: Stack(
                    // Use Stack to layer drawer content and item selector.
                    children: [
                      createDrawer(menuController), // The main drawer content.
                      // Render the ItemSelector if animation is enabled and not a peek menu.
                      (widget.animation && !widget.peekMenu) &&
                              shouldRenderSelector
                          ? ItemSelector(
                              right: widget.direction ==
                                      Direction
                                          .right // Position selector on right if drawer is on right.
                                  ? maxSlideAmount - 10
                                  : null,
                              selectorColor: selectorColor,
                              top: actualSelectorYTop ?? 0,
                              bottom: actualSelectorYBottom ?? 0,
                              opacity: selectorOpacity)
                          : Container(), // Otherwise, an empty container.
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Static method to get the `_SideDrawerState` from the context.
  /// Used for accessing internal state from child widgets.
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

/// A widget that visually indicates the selected menu item. It animates implicitly.
class ItemSelector extends ImplicitlyAnimatedWidget {
  final double top; // Top position of the selector.
  final double bottom; // Bottom position of the selector.
  final double?
      right; // Right position of the selector (for right-aligned drawers).
  final double? opacity; // Opacity of the selector.

  final Color? selectorColor; // Color of the selector.

  /// Constructor for `ItemSelector`.
  ItemSelector({
    this.right,
    required this.top,
    required this.bottom,
    this.opacity,
    this.selectorColor,
  }) : super(
            duration: const Duration(
                milliseconds: 250)); // Default animation duration.

  @override
  _ItemSelectorState createState() => _ItemSelectorState();
}

/// The state for `ItemSelector`, handling the implicit animations of its properties.
class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  // Tweens for animating the selector's properties.
  Tween<double?>? _topY;
  Tween<double?>? _bottomY;
  Tween<double?>? _opacity;

  @override
  void forEachTween(visitor) {
    // Define and update tweens for top, bottom, and opacity properties.
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
      // Positions the selector absolutely within its parent Stack.
      top: _topY?.evaluate(animation), // Animated top position.
      right: widget.right, // Static right position.
      child: Opacity(
        opacity: _opacity?.evaluate(animation) ?? 0, // Animated opacity.
        child: Container(
          width: 5.0, // Fixed width of the selector.
          height: _bottomY!.evaluate(animation)! -
              _topY!.evaluate(animation)!, // Animated height.
          color: widget.selectorColor, // Selector's color.
        ),
      ),
    );
  }
}

/// A widget that animates the appearance and position of a menu list item.
class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final Widget? menuListItem; // The actual menu item widget.
  final MenuState? menuState; // Current state of the menu (e.g., closed, open).
  final bool? isSelected; // Whether this item is currently selected.
  final Duration duration; // Animation duration.

  /// Constructor for `AnimatedMenuListItem`.
  AnimatedMenuListItem({
    this.menuListItem,
    this.menuState,
    this.isSelected,
    required this.duration,
    required Curve curve, // Animation curve.
    Key? key,
  }) : super(
            key: key,
            duration: duration,
            curve:
                curve); // Pass duration and curve to ImplicitlyAnimatedWidget.

  @override
  _AnimatedMenuListItemState createState() => _AnimatedMenuListItemState();
}

/// The state for `AnimatedMenuListItem`, managing its implicit position and opacity animations.
class _AnimatedMenuListItemState
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition =
      200.0; // Initial slide position when closed.
  final double openSlidePosition = 0.0; // Final slide position when open.

  /// Convenience getter to access the parent `_SideDrawerState`.
  _SideDrawerState? get _sideDrawerState => _SideDrawerState.of(context);

  // Tweens for animating translation (slide) and opacity.
  Tween<double?>? _translation;
  Tween<double?>? _opacity;

  /// Updates the `_SideDrawerState` with the `RenderBox` of the selected item.
  updateSelectedRenderBox(bool useState) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && widget.isSelected!) {
      _sideDrawerState?.setSelectedRenderBox.call(renderBox, useState);
    }
  }

  @override
  void forEachTween(visitor) {
    var slide, opacity;

    // Determine target slide and opacity based on the menu state.
    switch (widget.menuState) {
      case MenuState.closed:
      case MenuState.closing:
        slide = closedSlidePosition; // Slide out of view.
        opacity = 0.0; // Become transparent.
        break;
      case MenuState.open:
      case MenuState.opening:
        slide = openSlidePosition; // Slide into view.
        opacity = 1.0; // Become fully opaque.
        break;

      default:
        break;
    }

    // Define and update tweens.
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
    updateSelectedRenderBox(false); // Update selected item's RenderBox.

    return Opacity(
      opacity: _opacity!.evaluate(animation)!, // Apply animated opacity.
      child: Transform(
        transform: Matrix4.translationValues(
          0.0,
          _translation!
              .evaluate(animation)!, // Apply animated vertical translation.
          0.0,
        ),
        child: widget.menuListItem, // The actual menu item.
      ),
    );
  }
}
