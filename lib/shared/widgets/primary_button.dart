import 'package:flutter/material.dart';

/// A customizable primary action button.
///
/// This widget provides a consistent look for primary call-to-action buttons
/// throughout the app with full customization support.
///
/// Example usage:
/// ```dart
/// PrimaryButton(
///   onPressed: () => print('Pressed'),
///   label: 'Sign up',
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.height = 56.0,
    this.width,
    this.borderRadius = 12.0,
    this.fontSize,
    this.fontWeight,
    this.elevation = 0,
    this.icon,
    this.iconWidget,
    this.iconPosition = IconPosition.leading,
    this.loadingIndicatorColor,
    super.key,
  });

  /// Callback when button is pressed (null disables the button)
  final VoidCallback? onPressed;

  /// The text label displayed on the button
  final String label;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button is enabled
  final bool isEnabled;

  /// Background color of the button
  final Color? backgroundColor;

  /// Text color
  final Color? foregroundColor;

  /// Background color when disabled
  final Color? disabledBackgroundColor;

  /// Text color when disabled
  final Color? disabledForegroundColor;

  /// Height of the button
  final double height;

  /// Width of the button (null for full width)
  final double? width;

  /// Border radius of the button
  final double borderRadius;

  /// Font size of the label text
  final double? fontSize;

  /// Font weight of the label text
  final FontWeight? fontWeight;

  /// Elevation of the button
  final double elevation;

  /// Optional icon (Material Icons)
  final IconData? icon;

  /// Optional custom icon widget
  final Widget? iconWidget;

  /// Position of the icon
  final IconPosition iconPosition;

  /// Color of the loading indicator
  final Color? loadingIndicatorColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.onPrimary;
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.primary;

    final isButtonEnabled = isEnabled && !isLoading && onPressed != null;

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          disabledBackgroundColor: disabledBackgroundColor ??
              theme.colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: disabledForegroundColor ??
              theme.colorScheme.onSurface.withValues(alpha: 0.38),
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading ? _buildLoadingIndicator(context) : _buildContent(),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = loadingIndicatorColor ??
        foregroundColor ??
        theme.colorScheme.onPrimary;

    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );
  }

  Widget _buildContent() {
    final hasIcon = icon != null || iconWidget != null;

    if (!hasIcon) {
      return _buildLabel();
    }

    final iconContent = iconWidget ??
        Icon(
          icon,
          size: 20,
        );

    if (iconPosition == IconPosition.leading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconContent,
          const SizedBox(width: 8),
          _buildLabel(),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLabel(),
          const SizedBox(width: 8),
          iconContent,
        ],
      );
    }
  }

  Widget _buildLabel() {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
    );
  }
}

/// Position of the icon in a button
enum IconPosition {
  /// Icon appears before the label
  leading,

  /// Icon appears after the label
  trailing,
}

/// A secondary/outlined version of the button
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.isEnabled = true,
    this.foregroundColor,
    this.borderColor,
    this.height = 56.0,
    this.width,
    this.borderRadius = 12.0,
    this.fontSize,
    this.fontWeight,
    this.icon,
    this.iconWidget,
    this.iconPosition = IconPosition.leading,
    super.key,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool isEnabled;
  final Color? foregroundColor;
  final Color? borderColor;
  final double height;
  final double? width;
  final double borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final IconData? icon;
  final Widget? iconWidget;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveForegroundColor =
        foregroundColor ?? theme.colorScheme.primary;
    final effectiveBorderColor = borderColor ?? theme.colorScheme.outline;

    final isButtonEnabled = isEnabled && !isLoading && onPressed != null;

    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveForegroundColor,
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
                ),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final hasIcon = icon != null || iconWidget != null;

    if (!hasIcon) {
      return Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
      );
    }

    final iconContent = iconWidget ?? Icon(icon, size: 20);

    if (iconPosition == IconPosition.leading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconContent,
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          iconContent,
        ],
      );
    }
  }
}
