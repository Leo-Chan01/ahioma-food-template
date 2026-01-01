import 'package:equatable/equatable.dart';

enum TransactionType { order, topUp }

class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
    required this.type,
    this.imageUrl,
    this.productName,
  });

  final String id;
  final String title;
  final double amount;
  final String date;
  final String time;
  final TransactionType type;
  final String? imageUrl;
  final String? productName;

  @override
  List<Object?> get props => [
    id,
    title,
    amount,
    date,
    time,
    type,
    imageUrl,
    productName,
  ];
}
