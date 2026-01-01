import 'package:equatable/equatable.dart';

class PaginationEntity extends Equatable {
  const PaginationEntity({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  final int total;
  final int page;
  final int limit;
  final int totalPages;

  @override
  List<Object?> get props => [total, page, limit, totalPages];
}
