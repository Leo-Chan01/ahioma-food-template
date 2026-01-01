import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ahioma_food_template/shared/animations/animation_constants.dart';

/// A widget that fades in when it appears
class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.duration = AnimationConstants.normal,
    this.curve = AnimationConstants.enterCurve,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation =
        Tween<double>(
          begin: AnimationConstants.opacityHidden,
          end: AnimationConstants.opacityVisible,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.curve,
          ),
        );

    unawaited(
      Future.delayed(widget.delay, () {
        if (mounted) {
          unawaited(_controller.forward());
        }
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
