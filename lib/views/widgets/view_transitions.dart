import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

PageRouteBuilder<T> sharedAxisRoute<T>({
  required Widget page,
  SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: type,
        child: child,
      );
    },
  );
}

PageRouteBuilder<T> fadeThroughRoute<T>({required Widget page}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}
