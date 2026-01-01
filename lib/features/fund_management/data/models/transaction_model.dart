import 'package:ahioma_food_template/features/fund_management/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.time,
    required super.type,
    super.imageUrl,
    super.productName,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      time: json['time'] as String,
      type: json['type'] == 'topUp'
          ? TransactionType.topUp
          : TransactionType.order,
      imageUrl: json['imageUrl'] as String?,
      productName: json['productName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'time': time,
      'type': type == TransactionType.topUp ? 'topUp' : 'order',
      'imageUrl': imageUrl,
      'productName': productName,
    };
  }
}
