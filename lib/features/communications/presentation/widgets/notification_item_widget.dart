import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/features/communications/domain/entities/notification_entity.dart';

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({
    required this.notification,
    super.key,
  });

  final NotificationEntity notification;

  Widget _getIcon(NotificationType type, ThemeData theme) {
    switch (type) {
      case NotificationType.discount:
        return AppIcons.percentage(color: Colors.white, size: 24);
      case NotificationType.topUp:
        return AppIcons.wallet(color: Colors.white, size: 24);
      case NotificationType.service:
        return AppIcons.location(color: Colors.white, size: 24);
      case NotificationType.creditCard:
        return AppIcons.creditCard(color: Colors.white, size: 24);
      case NotificationType.account:
        return AppIcons.user(color: Colors.white, size: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: _getIcon(notification.type, theme),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
