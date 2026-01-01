import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/features/storefront/data/models/category_model.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    required this.categories,
    super.key,
    this.onCategoryTap,
  });

  final List<CategoryModel> categories;
  final void Function(String category)? onCategoryTap;

  /// Get icon for category based on name
  Widget _getCategoryIcon(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    if (lowerName.contains('clothes') || lowerName.contains('cloth')) {
      return AppIcons.clothes();
    } else if (lowerName.contains('shoe')) {
      return AppIcons.shoes();
    } else if (lowerName.contains('bag')) {
      return AppIcons.bag();
    } else if (lowerName.contains('electron')) {
      return AppIcons.electronics();
    } else if (lowerName.contains('watch')) {
      return AppIcons.watch();
    } else if (lowerName.contains('jewel')) {
      return AppIcons.jewelry();
    } else if (lowerName.contains('kitchen')) {
      return AppIcons.kitchen();
    } else if (lowerName.contains('toy')) {
      return AppIcons.toys();
    } else if (lowerName.contains('computer')) {
      return AppIcons.computers();
    }
    // Default icon
    return AppIcons.bag();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final hasImage =
              category.imageUrl != null && category.imageUrl!.isNotEmpty;

          return GestureDetector(
            onTap: () => onCategoryTap?.call(category.name),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: hasImage
                        ? Image.network(
                            category.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return IconTheme(
                                data: IconThemeData(
                                  color: theme.colorScheme.onSurface,
                                  size: 28,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: _getCategoryIcon(category.name),
                                ),
                              );
                            },
                          )
                        : IconTheme(
                            data: IconThemeData(
                              color: theme.colorScheme.onSurface,
                              size: 28,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: _getCategoryIcon(category.name),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
