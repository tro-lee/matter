import 'package:flutter/material.dart';

Route animateRoute({required Widget child, String direction = 'vertical'}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      late Offset begin;
      const end = Offset.zero;
      const curve = Curves.ease;

      if (direction == 'vertical') {
        begin = const Offset(0.0, 1.0);
      } else if (direction == 'horizontal') {
        begin = const Offset(1.0, 0.0);
      } else {
        throw ArgumentError('方向错误');
      }

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
