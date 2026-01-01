import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/notification_strings.dart';
import 'package:ahioma_food_template/features/communications/data/data_sources/local/notifications_local_source.dart';
import 'package:ahioma_food_template/features/communications/data/models/notification_model.dart';
import 'package:ahioma_food_template/features/communications/presentation/widgets/notification_group_header_widget.dart';
import 'package:ahioma_food_template/features/communications/presentation/widgets/notification_item_widget.dart';
import 'package:ahioma_food_template/features/communications/presentation/widgets/notifications_empty_state_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  static const String path = '/notifications';
  static const String name = 'notifications';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationsLocalSource _notificationsSource =
      NotificationsLocalSource();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await _notificationsSource.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getDateGroupHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return NotificationStrings.today;
    } else if (notificationDate == yesterday) {
      return NotificationStrings.yesterday;
    } else {
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Map<String, List<NotificationModel>> _groupNotificationsByDate() {
    final grouped = <String, List<NotificationModel>>{};
    for (final notification in _notifications) {
      final header = _getDateGroupHeader(notification.date);
      grouped.putIfAbsent(header, () => []).add(notification);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedNotifications = _groupNotificationsByDate();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          NotificationStrings.notification,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.moreVertical(
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : RefreshIndicator.adaptive(
              onRefresh: _loadNotifications,
              child: groupedNotifications.isEmpty
                  ? const NotificationsEmptyStateWidget()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: groupedNotifications.length,
                      itemBuilder: (context, index) {
                        final entry = groupedNotifications.entries.elementAt(
                          index,
                        );
                        final header = entry.key;
                        final notifications = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NotificationGroupHeaderWidget(header: header),
                            ...notifications.map(
                              (notification) => NotificationItemWidget(
                                notification: notification,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
    );
  }
}
