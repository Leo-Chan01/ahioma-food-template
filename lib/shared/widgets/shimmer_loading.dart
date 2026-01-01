// ignore_for_file: discarded_futures

import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    required this.child,
    super.key,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.period,
      vsync: this,
    );
    _animation =
        Tween<double>(
          begin: -1,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surface;
    final highlightColor =
        widget.highlightColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.1);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                baseColor.withValues(alpha: 0.5),
                highlightColor.withValues(alpha: 0.5),
                baseColor.withValues(alpha: 0.5),
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value * 3.14159),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// A simple shimmer text widget for loading states
class ShimmerText extends StatelessWidget {
  const ShimmerText({
    required this.text,
    super.key,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style:
              style?.copyWith(color: Colors.transparent) ??
              const TextStyle(color: Colors.transparent),
        ),
      ),
    );
  }
}
