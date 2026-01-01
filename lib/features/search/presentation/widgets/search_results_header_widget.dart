import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/strings/search_strings.dart';

class SearchResultsHeaderWidget extends StatelessWidget {
  const SearchResultsHeaderWidget({
    required this.query,
    required this.resultCount,
    super.key,
  });

  final String query;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${SearchStrings.resultsFor} '$query'",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$resultCount ${SearchStrings.founds}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
