import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  const FilterChips({
    required this.filters,
    this.selectedFilter,
    this.onFilterSelected,
    super.key,
  });

  final List<String> filters;
  final String? selectedFilter;
  final void Function(String filter)? onFilterSelected;

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter ?? widget.filters.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = widget.filters[index];
          final isSelected = filter == _selectedFilter;

          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            checkmarkColor: isSelected
                ? theme.colorScheme.surface
                : theme.colorScheme.onSurface,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
                widget.onFilterSelected?.call(filter);
              }
            },
            backgroundColor: theme.colorScheme.surface,
            selectedColor: theme.colorScheme.onSurface,
            labelStyle: TextStyle(
              color: isSelected
                  ? theme.colorScheme.surface
                  : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
