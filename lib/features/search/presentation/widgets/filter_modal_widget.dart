import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';
import 'package:ahioma_food_template/core/utils/strings/search_strings.dart';
import 'package:ahioma_food_template/features/search/domain/entities/search_filter_entity.dart';

class FilterModalWidget extends StatefulWidget {
  const FilterModalWidget({
    required this.filter,
    required this.onApply,
    super.key,
  });

  final SearchFilterEntity filter;
  final ValueChanged<SearchFilterEntity> onApply;

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late SearchFilterEntity _currentFilter;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.filter;
    _priceRange = RangeValues(_currentFilter.minPrice, _currentFilter.maxPrice);
  }

  void _resetFilters() {
    setState(() {
      _currentFilter = SearchFilterEntity(
        categories: _currentFilter.categories,
        sortOptions: _currentFilter.sortOptions,
        ratingOptions: _currentFilter.ratingOptions,
      );
      _priceRange = const RangeValues(0, 1000);
    });
  }

  void _applyFilters() {
    final updatedFilter = _currentFilter.copyWith(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
    );
    widget.onApply(updatedFilter);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              SearchStrings.sortAndFilter,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  _buildSection(
                    context,
                    SearchStrings.categories,
                    _buildCategoryChips(theme),
                  ),
                  // Price Range
                  _buildSection(
                    context,
                    SearchStrings.priceRange,
                    _buildPriceRangeSlider(theme),
                  ),
                  // Sort by
                  _buildSection(
                    context,
                    SearchStrings.sortBy,
                    _buildSortChips(theme),
                  ),
                  // Rating
                  _buildSection(
                    context,
                    SearchStrings.rating,
                    _buildRatingChips(theme),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(SearchStrings.reset),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(SearchStrings.apply),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildCategoryChips(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _currentFilter.categories.length,
        itemBuilder: (context, index) {
          final category = _currentFilter.categories[index];
          final isSelected = _currentFilter.selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(
                    selectedCategory: selected ? category : null,
                  );
                });
              },
              selectedColor: theme.colorScheme.onSurface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceRangeSlider(ThemeData theme) {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          max: 1000,
          divisions: 100,
          labels: RangeLabels(
            _priceRange.start.toNGN(),
            _priceRange.end.toNGN(),
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _priceRange.start.toNGN(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _priceRange.end.toNGN(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortChips(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _currentFilter.sortOptions.length,
        itemBuilder: (context, index) {
          final sortOption = _currentFilter.sortOptions[index];
          final isSelected = _currentFilter.sortBy == sortOption;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(sortOption),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(
                    sortBy: selected ? sortOption : null,
                  );
                });
              },
              selectedColor: theme.colorScheme.onSurface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRatingChips(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _currentFilter.ratingOptions.length,
        itemBuilder: (context, index) {
          final ratingOption = _currentFilter.ratingOptions[index];
          final ratingValue = ratingOption == SearchStrings.all
              ? null
              : double.tryParse(ratingOption);
          final isSelected = _currentFilter.minRating == ratingValue;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcons.star(
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ratingOption == SearchStrings.all
                        ? SearchStrings.all
                        : ratingOption,
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(
                    minRating: selected ? ratingValue : null,
                  );
                });
              },
              selectedColor: theme.colorScheme.onSurface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
