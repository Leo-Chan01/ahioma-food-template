import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';

class RecentSearchItemWidget extends StatelessWidget {
  const RecentSearchItemWidget({
    required this.query,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final String query;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                query,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: AppIcons.close(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
