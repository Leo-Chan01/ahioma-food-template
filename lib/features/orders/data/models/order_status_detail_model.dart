import 'package:ahioma_food_template/features/orders/domain/entities/order_status_detail_entity.dart';

class OrderStatusDetailModel extends OrderStatusDetailEntity {
  const OrderStatusDetailModel({
    required super.title,
    required super.description,
    required super.date,
    required super.time,
    required super.isCompleted,
  });

  factory OrderStatusDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusDetailModel(
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'isCompleted': isCompleted,
    };
  }
}
