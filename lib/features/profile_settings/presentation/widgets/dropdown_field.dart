import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({
    required this.controller,
    required this.label,
    required this.items,
    required this.onSelected,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final List<String> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        _showDropdown(context, items, onSelected);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: AppIcons.chevronDown(
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
        child: Text(
          controller.text,
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }

  void _showDropdown(
    BuildContext context,
    List<String> items,
    ValueChanged<String> onSelected,
  ) {
    showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(item),
              onTap: () {
                onSelected(item);
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }
}
