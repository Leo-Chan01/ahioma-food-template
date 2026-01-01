import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ahioma_food_template/shared/animations/animation_constants.dart';

/// A widget that scales down when pressed for a tactile tap interaction
class AnimatedTapScale extends StatefulWidget {
  const AnimatedTapScale({
    required this.child,
    super.key,
    this.onTap,
    this.scaleValue = AnimationConstants.scaleMin,
    this.duration = AnimationConstants.fast,
    this.curve = AnimationConstants.defaultCurve,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleValue;
  final Duration duration;
  final Curve curve;
  final bool enabled;

  @override
  State<AnimatedTapScale> createState() => _AnimatedTapScaleState();
}

class _AnimatedTapScaleState extends State<AnimatedTapScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(
          begin: AnimationConstants.scaleNormal,
          end: widget.scaleValue,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.curve,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enabled && widget.onTap != null) {
      unawaited(_controller.forward());
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enabled) {
      unawaited(_controller.reverse());
    }
  }

  void _onTapCancel() {
    if (widget.enabled) {
      unawaited(_controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.enabled ? widget.onTap : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
