import 'package:equatable/equatable.dart';

/// Expense entity (domain layer)
class Expense extends Equatable {
  final String id;
  final String category;
  final double amount;
  final String currency;
  final double amountInUSD;
  final DateTime date;
  final String? receiptPath;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.currency,
    required this.amountInUSD,
    required this.date,
    this.receiptPath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    category,
    amount,
    currency,
    amountInUSD,
    date,
    receiptPath,
    createdAt,
  ];
}
