import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';

/// A widget for displaying illustrations in authentication screens.
///
/// This widget can display images from assets, network, or custom widgets
/// with consistent sizing and styling across auth screens.
///
/// Example usage:
/// ```dart
/// AuthIllustration.asset(
///   assetPath: 'assets/images/login_illustration.png',
///   height: 250,
/// )
/// ```
class AuthIllustration extends StatelessWidget {
  const AuthIllustration({
    required this.child,
    this.width,
    this.height = 200.0,
    this.fit = BoxFit.contain,
    this.padding = const EdgeInsets.all(24),
    this.alignment = Alignment.center,
    super.key,
  });

  /// Creates an illustration from an asset image
  factory AuthIllustration.asset({
    required String assetPath,
    double? width,
    double height = 200.0,
    BoxFit fit = BoxFit.contain,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    Alignment alignment = Alignment.center,
  }) {
    return AuthIllustration(
      width: width,
      height: height,
      fit: fit,
      padding: padding,
      alignment: alignment,
      child: Image.asset(
        assetPath,
        fit: fit,
      ),
    );
  }

  /// Creates an illustration from a network image
  factory AuthIllustration.network({
    required String url,
    double? width,
    double height = 200.0,
    BoxFit fit = BoxFit.contain,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    Alignment alignment = Alignment.center,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return AuthIllustration(
      width: width,
      height: height,
      fit: fit,
      padding: padding,
      alignment: alignment,
      child: Image.network(
        url,
        fit: fit,
        loadingBuilder: placeholder != null
            ? (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return placeholder;
              }
            : null,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget
            : null,
      ),
    );
  }

  /// Creates a placeholder illustration with an icon
  factory AuthIllustration.placeholder({
    Widget? iconWidget,
    double? width,
    double height = 200,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    Alignment alignment = Alignment.center,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return AuthIllustration(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Container(
            decoration: BoxDecoration(
              color:
                  backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child:
                  iconWidget ??
                  AppIcons.login(
                    color: iconColor ?? theme.colorScheme.onSurfaceVariant,
                    size: 80,
                  ),
            ),
          );
        },
      ),
    );
  }

  /// The widget to display (typically an Image)
  final Widget child;

  /// Width of the illustration container
  final double? width;

  /// Height of the illustration container
  final double height;

  /// How to fit the image within the container
  final BoxFit fit;

  /// Padding around the illustration
  final EdgeInsetsGeometry padding;

  /// Alignment of the illustration within its container
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }
}
