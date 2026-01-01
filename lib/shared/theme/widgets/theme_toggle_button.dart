import 'package:flutter/material.dart';
import 'package:ahioma_food_template/shared/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return PopupMenuButton<AppThemeMode>(
          icon: Icon(
            _getThemeIcon(themeProvider.themeMode),
            color: theme.colorScheme.onSurface,
          ),
          onSelected: (AppThemeMode mode) {
            themeProvider.setThemeMode(mode);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<AppThemeMode>(
              value: AppThemeMode.light,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: themeProvider.themeMode == AppThemeMode.light
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Light',
                    style: TextStyle(
                      color: themeProvider.themeMode == AppThemeMode.light
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<AppThemeMode>(
              value: AppThemeMode.dark,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: themeProvider.themeMode == AppThemeMode.dark
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dark',
                    style: TextStyle(
                      color: themeProvider.themeMode == AppThemeMode.dark
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<AppThemeMode>(
              value: AppThemeMode.system,
              child: Row(
                children: [
                  Icon(
                    Icons.settings_suggest,
                    color: themeProvider.themeMode == AppThemeMode.system
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'System',
                    style: TextStyle(
                      color: themeProvider.themeMode == AppThemeMode.system
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getThemeIcon(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.settings_suggest;
    }
  }
}
