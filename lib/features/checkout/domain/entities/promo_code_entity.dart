import 'package:equatable/equatable.dart';

class PromoCodeEntity extends Equatable {
  const PromoCodeEntity({
    required this.id,
    required this.code,
    required this.discountPercent,
    required this.description,
  });

  final String id;
  final String code;
  final int discountPercent;
  final String description;

  @override
  List<Object?> get props => [id, code, discountPercent, description];
}
