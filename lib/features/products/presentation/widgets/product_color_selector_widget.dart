import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/product_strings.dart';

class ProductColorSelectorWidget extends StatelessWidget {
  const ProductColorSelectorWidget({
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    super.key,
  });

  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ProductStrings.color,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: colors.map((color) {
            final isSelected = selectedColor == color;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: AppIcons.check(
                          color: Colors.white,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
