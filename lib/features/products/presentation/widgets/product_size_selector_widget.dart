import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/strings/product_strings.dart';

class ProductSizeSelectorWidget extends StatelessWidget {
  const ProductSizeSelectorWidget({
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    super.key,
  });

  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ProductStrings.size,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: sizes.map((size) {
            final isSelected = selectedSize == size;
            return GestureDetector(
              onTap: () => onSizeSelected(size),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                child: Center(
                  child: Text(
                    size,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
