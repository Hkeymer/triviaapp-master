import 'package:flutter/material.dart';

class MenuItemModel {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  MenuItemModel({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
}
