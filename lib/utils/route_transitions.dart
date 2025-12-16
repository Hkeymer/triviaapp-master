// lib/utils/route_transitions.dart
import 'package:flutter/material.dart';

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 280),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, sec, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}
