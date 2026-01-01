import 'dart:async';

import 'package:flutter/material.dart';

/// A widget that shows a ripple/shimmer effect when tapped
/// Perfect for image tiles, cards, etc.
class ShimmerTapEffect extends StatefulWidget {
  const ShimmerTapEffect({
    required this.child,
    super.key,
    this.onTap,
    this.rippleColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;

  @override
  State<ShimmerTapEffect> createState() => _ShimmerTapEffectState();
}

class _ShimmerTapEffectState extends State<ShimmerTapEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      unawaited(_controller.forward(from: 0));
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - _animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: _animation.value * 2,
                        colors: [
                          widget.rippleColor?.withValues(alpha: 0.3) ??
                              Colors.white.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
