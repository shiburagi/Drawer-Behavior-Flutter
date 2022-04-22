import 'package:flutter/material.dart' hide MenuItem;

class Menu<T> {
  final List<MenuItem<T>> items;

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
