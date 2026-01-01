import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';

class ProfileDatePickerField extends StatelessWidget {
  const ProfileDatePickerField({
    required this.controller,
    required this.label,
    required this.onTap,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: AppIcons.calendar(
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
        child: Text(
          controller.text.isEmpty ? '' : controller.text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
