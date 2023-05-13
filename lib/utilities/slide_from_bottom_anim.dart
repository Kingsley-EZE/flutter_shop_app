import 'package:flutter/material.dart';

class SlideFromBottomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int durationMs;

  SlideFromBottomPageRoute({required this.child, required this.durationMs})
      : super(
      transitionDuration: Duration(milliseconds: durationMs),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return child;
      },
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      });
}
