import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/strings/search_strings.dart';
import 'package:ahioma_food_template/features/search/presentation/widgets/recent_search_item_widget.dart';

class RecentSearchesWidget extends StatelessWidget {
  const RecentSearchesWidget({
    required this.recentSearches,
    required this.onSearchTap,
    required this.onClearAll,
    super.key,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onSearchTap;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SearchStrings.recent,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                child: const Text(SearchStrings.clearAll),
              ),
            ],
          ),
        ),
        ...recentSearches.map(
          (search) => RecentSearchItemWidget(
            query: search,
            onTap: () => onSearchTap(search),
            onDelete: () {
              // Delete logic handled by parent
              onSearchTap('__DELETE__$search');
            },
          ),
        ),
      ],
    );
  }
}
