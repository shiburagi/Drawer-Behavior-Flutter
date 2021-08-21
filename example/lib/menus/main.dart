import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

List<MenuItem<int>> items = [
  new MenuItem<int>(
    id: 0,
    title: 'THE PADDOCK',
    prefix: Icon(Icons.fastfood),
  ),
  new MenuItem<int>(
    id: 1,
    title: 'THE HERO',
    prefix: Icon(Icons.person),
  ),
  new MenuItem<int>(
    id: 2,
    title: 'HELP US GROW',
    prefix: Icon(Icons.terrain),
  ),
  new MenuItem<int>(
    id: 3,
    title: 'SETTINGS',
    prefix: Icon(Icons.settings),
  ),
];
final menu = Menu(
  items: items.map((e) => e.copyWith(prefix: null)).toList(),
);

final menuWithIcon = Menu<int>(
  items: items,
);
