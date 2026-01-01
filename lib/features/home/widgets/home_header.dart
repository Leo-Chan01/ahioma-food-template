import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/l10n/l10n.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.userName,
    this.avatarUrl,
    this.onNotificationTap,
    this.onFavoriteTap,
  });

  final String? userName;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    // Default location - you can make this dynamic from user settings later
    const String deliveryLocation = 'Times Square';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
            child: hasAvatar
                ? null
                : AppIcons.user(
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 12),

          // Delivery Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeDeliverTo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        deliveryLocation,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Notification Icon
          IconButton(
            onPressed: onNotificationTap,
            icon: AppIcons.notification(color: theme.colorScheme.onSurface),
          ),

          // Favorite Icon
          IconButton(
            onPressed: onFavoriteTap,
            icon: AppIcons.favorite(color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
