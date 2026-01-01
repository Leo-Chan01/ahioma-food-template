import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';

/// A highly customizable text field designed for authentication forms.
///
/// This widget provides a consistent look for auth-related input fields
/// with support for icons, validation, password visibility toggle, and more.
///
/// Example usage:
/// ```dart
/// AuthTextField(
///   controller: emailController,
///   hintText: 'Email',
///   prefixIcon: Icons.email,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.prefixIconWidget,
    this.suffixIcon,
    this.suffixIconWidget,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enablePasswordToggle = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.fillColor,
    this.borderRadius = 12.0,
    this.contentPadding,
    this.prefixIconColor,
    this.suffixIconColor,
    super.key,
  });

  /// Controller for the text field
  final TextEditingController? controller;

  /// Focus node for the text field
  final FocusNode? focusNode;

  /// Hint text displayed when field is empty
  final String? hintText;

  /// Label text displayed above the field
  final String? labelText;

  /// Helper text displayed below the field
  final String? helperText;

  /// Error text displayed below the field
  final String? errorText;

  /// Prefix icon (Material Icons)
  final IconData? prefixIcon;

  /// Custom prefix widget
  final Widget? prefixIconWidget;

  /// Suffix icon (Material Icons)
  final IconData? suffixIcon;

  /// Custom suffix widget
  final Widget? suffixIconWidget;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Callback when field is tapped
  final VoidCallback? onTap;

  /// Validator function for form validation
  final FormFieldValidator<String>? validator;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Enable password visibility toggle button
  final bool enablePasswordToggle;

  /// Whether field is enabled
  final bool enabled;

  /// Whether field is read-only
  final bool readOnly;

  /// Whether field should autofocus
  final bool autofocus;

  /// Maximum number of lines
  final int? maxLines;

  /// Minimum number of lines
  final int? minLines;

  /// Maximum character length
  final int? maxLength;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Fill color of the field
  final Color? fillColor;

  /// Border radius
  final double borderRadius;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  /// Prefix icon color
  final Color? prefixIconColor;

  /// Suffix icon color
  final Color? suffixIconColor;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine suffix icon
    Widget? suffixWidget;
    if (widget.enablePasswordToggle) {
      suffixWidget = IconButton(
        icon: _obscureText
            ? AppIcons.eyeHide(
                color:
                    widget.suffixIconColor ??
                    theme.colorScheme.onSurfaceVariant,
                size: 20,
              )
            : AppIcons.eyeShow(
                color:
                    widget.suffixIconColor ??
                    theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
        onPressed: _togglePasswordVisibility,
      );
    } else if (widget.suffixIconWidget != null) {
      suffixWidget = widget.suffixIconWidget;
    } else if (widget.suffixIcon != null) {
      suffixWidget = Icon(
        widget.suffixIcon,
        color: widget.suffixIconColor ?? theme.colorScheme.onSurfaceVariant,
      );
    }

    // Determine prefix icon
    Widget? prefixWidget;
    if (widget.prefixIconWidget != null) {
      prefixWidget = widget.prefixIconWidget;
    } else if (widget.prefixIcon != null) {
      prefixWidget = Icon(
        widget.prefixIcon,
        color: widget.prefixIconColor ?? theme.colorScheme.onSurfaceVariant,
      );
    }

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16),
          child: prefixWidget,
        ),
        suffixIcon: suffixWidget,
        filled: true,
        fillColor: widget.fillColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
    );
  }
}
