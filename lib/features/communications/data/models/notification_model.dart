import 'package:ahioma_food_template/features/communications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.date,
    required super.type,
    super.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationType type;
    switch (json['type'] as String) {
      case 'discount':
        type = NotificationType.discount;
      case 'topUp':
        type = NotificationType.topUp;
      case 'service':
        type = NotificationType.service;
      case 'creditCard':
        type = NotificationType.creditCard;
      case 'account':
        type = NotificationType.account;
      default:
        type = NotificationType.account;
    }

    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      date: DateTime.parse(json['date'] as String),
      type: type,
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
