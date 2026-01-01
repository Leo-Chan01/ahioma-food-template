import 'package:equatable/equatable.dart';

enum NotificationType {
  discount,
  topUp,
  service,
  creditCard,
  account,
}

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.type,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final NotificationType type;
  final bool isRead;

  @override
  List<Object?> get props => [id, title, subtitle, date, type, isRead];
}

