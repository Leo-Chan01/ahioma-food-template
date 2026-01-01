import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/features/profile_settings/domain/entities/profile_menu_item_entity.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  const ProfileMenuItemWidget({
    required this.menuItem,
    super.key,
  });

  final ProfileMenuItemEntity menuItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = menuItem.isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: menuItem.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            menuItem.iconBuilder(),
            const SizedBox(width: 16),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (menuItem.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      menuItem.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Right side widget (toggle or arrow)
            if (menuItem.type == ProfileMenuItemType.toggle)
              Switch(
                value: menuItem.isToggleOn,
                onChanged: menuItem.onToggleChanged,
                activeThumbColor: theme.colorScheme.primary,
              )
            else if (menuItem.type == ProfileMenuItemType.navigation ||
                menuItem.type == ProfileMenuItemType.action)
              AppIcons.arrowRight(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
