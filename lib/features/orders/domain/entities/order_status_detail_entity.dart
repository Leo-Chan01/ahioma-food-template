import 'package:equatable/equatable.dart';

class OrderStatusDetailEntity extends Equatable {
  const OrderStatusDetailEntity({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.isCompleted,
  });

  final String title;
  final String description;
  final String date;
  final String time;
  final bool isCompleted;

  @override
  List<Object?> get props => [title, description, date, time, isCompleted];
}
