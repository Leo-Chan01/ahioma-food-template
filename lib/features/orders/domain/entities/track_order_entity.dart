import 'package:equatable/equatable.dart';

class TrackOrderEntity extends Equatable {
  const TrackOrderEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
  });

  final String? id;
  final String? orderNumber;
  final String? status;
  final String? paymentStatus;

  @override
  List<Object?> get props => [id, orderNumber, status, paymentStatus];
}
