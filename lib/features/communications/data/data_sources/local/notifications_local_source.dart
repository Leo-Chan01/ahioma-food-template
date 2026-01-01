import 'package:ahioma_food_template/features/communications/data/models/notification_model.dart';

class NotificationsLocalSource {
  factory NotificationsLocalSource() {
    return _instance;
  }
  NotificationsLocalSource._();

  static final NotificationsLocalSource _instance =
      NotificationsLocalSource._();

  final List<Map<String, dynamic>> _notificationsDatabase = [
    {
      'id': '1',
      'title': '30% Special Discount!',
      'subtitle': 'Special promotion only valid today',
      'date': DateTime.now().toIso8601String(),
      'type': 'discount',
    },
    {
      'id': '2',
      'title': 'Top Up E-Wallet Successful!',
      'subtitle': 'You have to top up your e-wallet',
      'date': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
      'type': 'topUp',
    },
    {
      'id': '3',
      'title': 'New Services Available!',
      'subtitle': 'Now you can track orders in real time',
      'date': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
      'type': 'service',
    },
    {
      'id': '4',
      'title': 'Credit Card Connected!',
      'subtitle': 'Credit Card has been linked!',
      'date': DateTime(2024, 12, 22).toIso8601String(),
      'type': 'creditCard',
    },
    {
      'id': '5',
      'title': 'Account Setup Successful!',
      'subtitle': 'Your account has been created!',
      'date': DateTime(2024, 12, 22).toIso8601String(),
      'type': 'account',
    },
  ];

  Future<List<NotificationModel>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _notificationsDatabase.map(NotificationModel.fromJson).toList();
  }
}
