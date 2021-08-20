import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

class MenuListItem extends StatelessWidget {
  final String title;
  final bool? isSelected;
  final bool drawBorder;
  final Color? selectorColor;
  final TextStyle? textStyle;
  final SideDrawer? menuView;
  final Widget? icon;
  final Widget? suffix;
  final Direction direction;
  final double? width;
  final EdgeInsets? padding;

  MenuListItem({
    required this.title,
    this.isSelected,
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
    return Stack(
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
    );
  }
}
