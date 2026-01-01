import 'package:flutter/material.dart';

/// A checkbox with an associated label text.
///
/// This widget provides a clickable checkbox with label that can be
/// fully customized for auth forms and settings screens.
///
/// Example usage:
/// ```dart
/// LabeledCheckbox(
///   label: 'Remember me',
///   value: _rememberMe,
///   onChanged: (value) => setState(() => _rememberMe = value),
/// )
/// ```
class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    this.labelWidget,
    this.activeColor,
    this.checkColor,
    this.labelStyle,
    this.spacing = 8.0,
    this.contentPadding = EdgeInsets.zero,
    super.key,
  });

  /// The label text displayed next to the checkbox
  final String label;

  /// Custom widget for the label (overrides label text)
  final Widget? labelWidget;

  /// Current value of the checkbox
  final bool value;

  /// Callback when checkbox value changes
  final ValueChanged<bool> onChanged;

  /// Color of the checkbox when checked
  final Color? activeColor;

  /// Color of the checkmark
  final Color? checkColor;

  /// Style for the label text
  final TextStyle? labelStyle;

  /// Spacing between checkbox and label
  final double spacing;

  /// Padding around the entire widget
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: contentPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: value,
                onChanged: (newValue) => onChanged(newValue ?? false),
                activeColor: activeColor ?? theme.colorScheme.primary,
                checkColor: checkColor ?? theme.colorScheme.onPrimary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(width: spacing),
            if (labelWidget != null)
              Flexible(child: labelWidget!)
            else
              Flexible(
                child: Text(
                  label,
                  style: labelStyle ?? theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A checkbox with label that includes additional trailing widget
/// (like a "Forgot password?" link)
class LabeledCheckboxWithTrailing extends StatelessWidget {
  const LabeledCheckboxWithTrailing({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.trailing,
    this.activeColor,
    this.checkColor,
    this.labelStyle,
    this.spacing = 8.0,
    super.key,
  });

  /// The label text displayed next to the checkbox
  final String label;

  /// Current value of the checkbox
  final bool value;

  /// Callback when checkbox value changes
  final ValueChanged<bool> onChanged;

  /// Widget displayed on the trailing side
  final Widget trailing;

  /// Color of the checkbox when checked
  final Color? activeColor;

  /// Color of the checkmark
  final Color? checkColor;

  /// Style for the label text
  final TextStyle? labelStyle;

  /// Spacing between checkbox and label
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LabeledCheckbox(
            label: label,
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
            checkColor: checkColor,
            labelStyle: labelStyle,
            spacing: spacing,
          ),
        ),
        trailing,
      ],
    );
  }
}
