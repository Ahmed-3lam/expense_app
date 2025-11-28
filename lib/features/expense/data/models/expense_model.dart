import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String currency;

  @HiveField(4)
  final double amountInUSD;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String? receiptPath;

  @HiveField(7)
  final DateTime createdAt;

  const ExpenseModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.currency,
    required this.amountInUSD,
    required this.date,
    this.receiptPath,
    required this.createdAt,
  });

  /// Create a copy with updated fields
  ExpenseModel copyWith({
    String? id,
    String? category,
    double? amount,
    String? currency,
    double? amountInUSD,
    DateTime? date,
    String? receiptPath,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      amountInUSD: amountInUSD ?? this.amountInUSD,
      date: date ?? this.date,
      receiptPath: receiptPath ?? this.receiptPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'currency': currency,
      'amountInUSD': amountInUSD,
      'date': date.toIso8601String(),
      'receiptPath': receiptPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      amountInUSD: (json['amountInUSD'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      receiptPath: json['receiptPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

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
