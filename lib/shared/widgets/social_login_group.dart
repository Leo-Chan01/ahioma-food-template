import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';

/// A widget that groups social login icons in a row.
///
/// This widget is useful for displaying social login options
/// in a compact horizontal layout (typically with icon-only buttons).
///
/// Example usage:
/// ```dart
/// SocialLoginGroup(
///   buttons: [
///     SocialIconButton(
///       onPressed: () => print('Facebook'),
///       icon: Icons.facebook,
///     ),
///     SocialIconButton(
///       onPressed: () => print('Google'),
///       icon: Icons.g_mobiledata,
///     ),
///   ],
/// )
/// ```
class SocialLoginGroup extends StatelessWidget {
  const SocialLoginGroup({
    required this.buttons,
    this.spacing = 16.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    super.key,
  });

  /// List of social login button widgets
  final List<Widget> buttons;

  /// Spacing between buttons
  final double spacing;

  /// Horizontal alignment of the buttons
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        for (var i = 0; i < buttons.length; i++) ...[
          buttons[i],
          if (i < buttons.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}

/// A circular icon button for social login.
///
/// This is designed for compact social login displays where
/// only the icon is shown without text.
class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    required this.onPressed,
    required this.socialLginName,
    this.icon,
    this.iconWidget,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.size = 56.0,
    this.iconSize = 24.0,
    this.elevation = 0,

    super.key,
  }) : assert(
         icon != null || iconWidget != null,
         'Either icon or iconWidget must be provided',
       );

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// Icon data for the button (if using Material Icons)
  final IconData? icon;

  /// Custom widget for the icon (for SVG or custom icons)
  final Widget? iconWidget;

  /// Background color of the button
  final Color? backgroundColor;

  /// Color of the icon
  final Color? iconColor;

  /// Border color (if null, no border is shown)
  final Color? borderColor;

  /// Size of the button (width and height)
  final double size;

  /// Size of the icon
  final double iconSize;

  /// Elevation of the button
  final double elevation;

  final String socialLginName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.surface;
    final effectiveIconColor = iconColor ?? theme.colorScheme.onSurface;

    return Material(
      color: effectiveBackgroundColor,
      elevation: elevation,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.5)
                : Border.all(color: theme.colorScheme.outline, width: 1.5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget ??
                  Icon(icon, size: iconSize, color: effectiveIconColor),
              SizedBox(width: MediaQuery.sizeOf(context).width * 0.05),
              Text(socialLginName),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pre-configured social icon button variants
class SocialIconButtons {
  /// Facebook icon button
  static Widget facebook({required VoidCallback onPressed, double size = 56}) {
    return SocialIconButton(
      onPressed: onPressed,
      socialLginName: 'Continue with Facebook',
      iconWidget: AppIcons.facebook(color: const Color(0xFF1877F2), size: 24),
      size: size,
    );
  }

  /// Google icon button
  static Widget google({required VoidCallback onPressed, double size = 56}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return SocialIconButton(
          onPressed: onPressed,
          socialLginName: 'Continue with Google',
          iconWidget: Image.asset(
            // color: theme.colorScheme.onSurface,
            height: 30,
            width: 30,
            'assets/images/google-icon.png',
          ),
          size: size,
        );
      },
    );
  }

  /// Apple icon button
  static Widget apple({required VoidCallback onPressed, double size = 56}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return SocialIconButton(
          onPressed: onPressed,
          socialLginName: 'Continue with Apple',
          iconWidget: Image.asset(
            color: theme.colorScheme.onSurface,
            height: 30,
            width: 30,
            'assets/images/apple-icon.png',
          ),
          size: size,
        );
      },
    );
  }
}
