
import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 2)
class Budget {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime month;

  Budget({
    required this.category,
    required this.amount,
    required this.month,
  });

  Budget copyWith({
    String? category,
    double? amount,
    DateTime? month,
  }) {
    return Budget(
      category: category ?? this.category,
      amount: amount ?? this.amount,
      month: month ?? this.month,
    );
  }
}