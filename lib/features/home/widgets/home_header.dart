import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';

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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = (userName?.trim().isNotEmpty ?? false)
        ? userName!.trim()
        : 'Guest Shopper';
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

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

          // Greeting and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()} 👋',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Notification Icon
          IconButton(
            onPressed: onNotificationTap,
            icon: AppIcons.notification(
              color: theme.colorScheme.onSurface,
            ),
          ),

          // Favorite Icon
          IconButton(
            onPressed: onFavoriteTap,
            icon: AppIcons.favorite(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
