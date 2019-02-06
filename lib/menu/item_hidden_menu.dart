import 'package:flutter/material.dart';

class ItemHiddenMenu extends StatelessWidget {
  /// name of the components.drawer.menu item
  final String name;

  /// callback to recibe action click in item
  final Function onTap;

  /// color used for selected item in line
  final Color colorLineSelected;

  /// color used in text for selected item
  final Color colorTextSelected;

  /// color used in text for unselected item
  final Color colorTextUnSelected;

  final bool selected;

  ItemHiddenMenu(
      {Key key,
      this.name,
      this.selected = false,
      this.onTap,
      this.colorLineSelected ,
      this.colorTextSelected= Colors.white,
      this.colorTextUnSelected = Colors.grey})
      : super(key: key);

  @override
  StatelessElement createElement() {
    return super.createElement();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0)),
              child: Container(
                height: 40.0,
                color: selected
                    ? colorLineSelected == null
                        ? Theme.of(context).accentColor
                        : colorLineSelected
                    : Colors.transparent,
                width: 5.0,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  name,
                  style: TextStyle(
                      color: selected ? colorTextSelected : colorTextUnSelected,
                      fontSize: 25.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
