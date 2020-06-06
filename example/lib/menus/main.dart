import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';

List<MenuItem> items = [
  new MenuItem<int>(
    id: 0,
    title: 'THE PADDOCK',
    icon: Icons.fastfood,
  ),
  new MenuItem<int>(
    id: 1,
    title: 'THE HERO',
    icon: Icons.person,
  ),
  new MenuItem<int>(
    id: 2,
    title: 'HELP US GROW',
    icon: Icons.terrain,
  ),
  new MenuItem<int>(
    id: 3,
    title: 'SETTINGS',
    icon: Icons.settings,
  ),
];
final menu = Menu(
  items: items.map((e) => e.copyWith(icon: null)).toList(),
);

final menuWithIcon = Menu(
  items: items,
);
