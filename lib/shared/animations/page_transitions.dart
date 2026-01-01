import 'package:flutter/material.dart';
import 'package:ahioma_food_template/shared/animations/animation_constants.dart';

/// Custom page transitions for the app
class PageTransitions {
  PageTransitions._();

  /// Slide transition from right
  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1, 0);
    const end = Offset.zero;

    final tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: AnimationConstants.smoothCurve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Slide transition from bottom
  static Widget slideFromBottom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0, 1);
    const end = Offset.zero;

    final tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: AnimationConstants.smoothCurve),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Fade transition
  static Widget fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Scale and fade transition
  static Widget scaleAndFade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final scaleTween = Tween<double>(begin: 0.9, end: 1).chain(
      CurveTween(curve: AnimationConstants.smoothCurve),
    );

    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation.drive(scaleTween),
        child: child,
      ),
    );
  }

  /// Slide and fade transition (combined)
  static Widget slideAndFade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.05, 0);
    const end = Offset.zero;

    final slideTween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: AnimationConstants.smoothCurve),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(slideTween),
        child: child,
      ),
    );
  }
}
