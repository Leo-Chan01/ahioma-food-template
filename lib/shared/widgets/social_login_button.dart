import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/auth_strings.dart';

/// A highly customizable social login button widget.
///
/// This widget provides a consistent look for social login buttons (Facebook, Google, Apple, etc.)
/// with full customization support for colors, sizes, icons, and text.
///
/// Example usage:
/// ```dart
/// SocialLoginButton(
///   onPressed: () => print('Facebook login'),
///   icon: Icons.facebook,
///   label: 'Continue with Facebook',
///   backgroundColor: Colors.blue,
/// )
/// ```
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.iconWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.height = 56.0,
    this.borderRadius = 12.0,
    this.iconSize = 24.0,
    this.fontSize,
    this.fontWeight,
    this.elevation = 0,
    this.shadowColor,
    super.key,
  }) : assert(
         icon != null || iconWidget != null,
         'Either icon or iconWidget must be provided',
       );

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// The text label displayed on the button
  final String label;

  /// Icon data for the button (if using Material Icons)
  final IconData? icon;

  /// Custom widget for the icon (for SVG or custom icons)
  final Widget? iconWidget;

  /// Background color of the button
  final Color? backgroundColor;

  /// Text and icon color
  final Color? foregroundColor;

  /// Border color (if null, no border is shown)
  final Color? borderColor;

  /// Height of the button
  final double height;

  /// Border radius of the button
  final double borderRadius;

  /// Size of the icon
  final double iconSize;

  /// Font size of the label text
  final double? fontSize;

  /// Font weight of the label text
  final FontWeight? fontWeight;

  /// Elevation of the button
  final double elevation;

  /// Shadow color of the button
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.onSurface;
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.surface;

    return Material(
      color: effectiveBackgroundColor,
      elevation: elevation,
      shadowColor: shadowColor ?? theme.shadowColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              if (iconWidget != null)
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: iconWidget,
                )
              else if (icon != null)
                Icon(
                  icon,
                  size: iconSize,
                  color: effectiveForegroundColor,
                ),

              const SizedBox(width: 12),

              // Label
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: effectiveForegroundColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight ?? FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pre-configured social login button variants for common platforms
class SocialLoginButtons {
  /// Facebook login button
  static Widget facebook({
    required VoidCallback onPressed,
    String label = AuthStrings.continueWithFacebook,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return SocialLoginButton(
          onPressed: onPressed,
          label: label,
          borderColor: theme.colorScheme.outline,
          iconWidget: AppIcons.facebook(
            color: const Color(0xFF1877F2),
          ),
          foregroundColor: const Color(0xFF1877F2),
        );
      },
    );
  }

  /// Google login button
  static Widget google({
    required VoidCallback onPressed,
    String label = AuthStrings.continueWithGoogle,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return SocialLoginButton(
          onPressed: onPressed,
          label: label,
          borderColor: theme.colorScheme.outline,
          iconWidget: AppIcons.google(
            color: theme.colorScheme.onSurface,
          ),
        );
      },
    );
  }

  /// Apple login button
  static Widget apple({
    required VoidCallback onPressed,
    String label = AuthStrings.continueWithApple,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return SocialLoginButton(
          onPressed: onPressed,
          label: label,
          borderColor: theme.colorScheme.outline,
          iconWidget: AppIcons.apple(
            color: theme.colorScheme.onSurface,
          ),
        );
      },
    );
  }
}
