import 'package:ahioma_food_template/features/orders/domain/entities/track_order_entity.dart';

class TrackOrderModel extends TrackOrderEntity {
  const TrackOrderModel({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.paymentStatus,
  });

  factory TrackOrderModel.fromJson(Map<String, dynamic> json) {
    return TrackOrderModel(
      id: json['id'] as String?,
      orderNumber: json['orderNumber'] as String?,
      status: json['status'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'status': status,
      'paymentStatus': paymentStatus,
    };
  }
}
