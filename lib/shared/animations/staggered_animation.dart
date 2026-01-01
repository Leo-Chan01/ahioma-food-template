import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ahioma_food_template/shared/animations/animation_constants.dart';

/// A widget that animates its child with a staggered delay
class StaggeredAnimation extends StatefulWidget {
  const StaggeredAnimation({
    required this.child,
    required this.index,
    super.key,
    this.delay = AnimationConstants.staggerDelay,
    this.duration = AnimationConstants.normal,
    this.curve = AnimationConstants.enterCurve,
    this.slideOffset = const Offset(0, 0.1),
  });

  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Offset slideOffset;

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation =
        Tween<double>(
          begin: AnimationConstants.opacityHidden,
          end: AnimationConstants.opacityVisible,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.curve,
          ),
        );

    _slideAnimation =
        Tween<Offset>(
          begin: widget.slideOffset,
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.curve,
          ),
        );

    // Start animation with delay based on index
    unawaited(
      Future.delayed(widget.delay * widget.index, () {
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
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
