import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Global SnackBar service that can be used without context
class GlobalSnackBar {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Get the global scaffold messenger key
  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  /// Show a success snackbar
  static void showSuccess(
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showSnackBar(
      message: message,
      type: SnackBarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Show an error snackbar
  static void showError(
    String message, {
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showSnackBar(
      message: message,
      type: SnackBarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Show a warning snackbar
  static void showWarning(
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showSnackBar(
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Show an info snackbar
  static void showInfo(
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showSnackBar(
      message: message,
      type: SnackBarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Show a custom snackbar
  static void showCustom({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    String? iconAsset,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showSnackBar(
      message: message,
      type: SnackBarType.custom,
      backgroundColor: backgroundColor,
      textColor: textColor,
      icon: icon,
      iconAsset: iconAsset,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  /// Hide current snackbar
  static void hide() {
    try {
      final scaffoldMessenger = _scaffoldMessengerKey.currentState;
      if (scaffoldMessenger != null && scaffoldMessenger.mounted) {
        scaffoldMessenger.hideCurrentSnackBar();
      }
    } catch (e) {
      // Silently handle errors when widget tree is deactivated
    }
  }

  /// Internal method to show snackbar
  static void _showSnackBar({
    required String message,
    required SnackBarType type,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    String? iconAsset,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final context = _scaffoldMessengerKey.currentContext;
    if (context == null) return;

    final scaffoldMessenger = _scaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null || !scaffoldMessenger.mounted) return;

    final theme = Theme.of(context);
    final snackBarConfig = _getSnackBarConfig(type, theme);

    try {
      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: duration,
            backgroundColor: backgroundColor ?? snackBarConfig.backgroundColor,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                // Icon
                if (iconAsset != null)
                  SvgPicture.asset(
                    iconAsset,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      textColor ?? snackBarConfig.textColor,
                      BlendMode.srcIn,
                    ),
                  )
                else if (icon != null || snackBarConfig.icon != null)
                  Icon(
                    icon ?? snackBarConfig.icon,
                    color: textColor ?? snackBarConfig.textColor,
                    size: 20,
                  ),

                if (iconAsset != null ||
                    icon != null ||
                    snackBarConfig.icon != null)
                  const SizedBox(width: 12),

                // Message
                Expanded(
                  child: SelectableText(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor ?? snackBarConfig.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            action: actionLabel != null
                ? SnackBarAction(
                    label: actionLabel,
                    textColor: textColor ?? snackBarConfig.textColor,
                    onPressed: onActionPressed ?? () {},
                  )
                : null,
          ),
        );
    } catch (e) {
      // Silently handle errors when widget tree is deactivated
    }
  }

  /// Get snackbar configuration based on type
  static _SnackBarConfig _getSnackBarConfig(
    SnackBarType type,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;
    switch (type) {
      case SnackBarType.success:
        // Use a green from tertiary or generate from theme, fallback to semantic green
        final successColor = colorScheme.tertiary.withValues(alpha: 0.9);
        return _SnackBarConfig(
          backgroundColor: successColor,
          textColor: colorScheme.onTertiary,
          icon: Icons.check_circle,
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          backgroundColor: colorScheme.error,
          textColor: colorScheme.onError,
          icon: Icons.error,
        );
      case SnackBarType.warning:
        // Use tertiary or a warm color from theme
        final warningColor = colorScheme.tertiaryContainer;
        return _SnackBarConfig(
          backgroundColor: warningColor,
          textColor: colorScheme.onTertiaryContainer,
          icon: Icons.warning,
        );
      case SnackBarType.info:
        // Use primary color from theme
        return _SnackBarConfig(
          backgroundColor: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          icon: Icons.info,
        );
      case SnackBarType.custom:
        return _SnackBarConfig(
          backgroundColor: colorScheme.surface,
          textColor: colorScheme.onSurface,
        );
    }
  }
}

/// SnackBar types
enum SnackBarType {
  success,
  error,
  warning,
  info,
  custom,
}

/// Internal snackbar configuration
class _SnackBarConfig {
  const _SnackBarConfig({
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
}
