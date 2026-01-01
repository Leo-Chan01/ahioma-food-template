import 'package:flutter/animation.dart';

/// Animation constants for consistent animations throughout the app
class AnimationConstants {
  AnimationConstants._();

  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration staggerDelay = Duration(milliseconds: 80);

  // Curves
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve enterCurve = Curves.easeOut;
  static const Curve exitCurve = Curves.easeIn;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOutCubicEmphasized;

  // Scale values
  static const double scaleMin = 0.95;
  static const double scaleNormal = 1;
  static const double scaleMax = 1.05;

  // Opacity values
  static const double opacityHidden = 0;
  static const double opacityVisible = 1;
  static const double opacityDisabled = 0.5;
}
