import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/l10n/l10n.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key, this.onTap, this.onFilterTap});

  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    AppIcons.search(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.l10n.searchPlaceholder,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onFilterTap,
              icon: AppIcons.filter(
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
