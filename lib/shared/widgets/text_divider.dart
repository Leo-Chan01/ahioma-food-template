import 'package:flutter/material.dart';

/// A horizontal divider with text in the middle.
///
/// Commonly used in auth screens to separate login methods
/// (e.g., "or continue with").
///
/// Example usage:
/// ```dart
/// TextDivider(text: 'or continue with')
/// ```
class TextDivider extends StatelessWidget {
  const TextDivider({
    required this.text,
    this.textStyle,
    this.dividerColor,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.spacing = 16.0,
    super.key,
  });

  /// The text displayed in the middle of the divider
  final String text;

  /// Style for the text
  final TextStyle? textStyle;

  /// Color of the divider lines
  final Color? dividerColor;

  /// Thickness of the divider lines
  final double thickness;

  /// Left indent of the divider
  final double indent;

  /// Right indent of the divider
  final double endIndent;

  /// Spacing between text and divider lines
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDividerColor =
        dividerColor ?? theme.colorScheme.outline.withValues(alpha: 0.3);
    final effectiveTextStyle = textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        );

    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: effectiveDividerColor,
              thickness: thickness,
              height: thickness,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: Text(
              text,
              style: effectiveTextStyle,
            ),
          ),
          Expanded(
            child: Divider(
              color: effectiveDividerColor,
              thickness: thickness,
              height: thickness,
            ),
          ),
        ],
      ),
    );
  }
}

/// A vertical divider with text in the middle.
class VerticalTextDivider extends StatelessWidget {
  const VerticalTextDivider({
    required this.text,
    this.textStyle,
    this.dividerColor,
    this.thickness = 1.0,
    this.height = 100.0,
    this.spacing = 8.0,
    super.key,
  });

  /// The text displayed in the middle of the divider
  final String text;

  /// Style for the text
  final TextStyle? textStyle;

  /// Color of the divider lines
  final Color? dividerColor;

  /// Thickness of the divider lines
  final double thickness;

  /// Total height of the divider
  final double height;

  /// Spacing between text and divider lines
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDividerColor =
        dividerColor ?? theme.colorScheme.outline.withValues(alpha: 0.3);
    final effectiveTextStyle = textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        );

    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: VerticalDivider(
              color: effectiveDividerColor,
              thickness: thickness,
              width: thickness,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing),
            child: Text(
              text,
              style: effectiveTextStyle,
            ),
          ),
          Expanded(
            child: VerticalDivider(
              color: effectiveDividerColor,
              thickness: thickness,
              width: thickness,
            ),
          ),
        ],
      ),
    );
  }
}
