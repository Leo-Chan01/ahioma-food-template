import 'package:flutter/material.dart';

class HelpCenterTabBar extends StatelessWidget implements PreferredSizeWidget {
  const HelpCenterTabBar({
    required this.controller,
    super.key,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TabBar(
      controller: controller,
      tabs: const [
        Tab(text: 'FAQ'),
        Tab(text: 'Contact us'),
      ],
      labelColor: colorScheme.onSurface,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      labelStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      indicatorColor: colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
