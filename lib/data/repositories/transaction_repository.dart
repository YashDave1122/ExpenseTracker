import 'package:hive/hive.dart';
import '../../core/models/transaction.dart';
import '../local_storage/hive_service.dart';

class TransactionRepository {
  final HiveService _hiveService;

  TransactionRepository(this._hiveService);

  Future<void> addTransaction(Transaction transaction) async {
    final box = _hiveService.transactionsBox;
    await box.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final box = _hiveService.transactionsBox;
    await box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    final box = _hiveService.transactionsBox;
    await box.delete(id);
  }

  List<Transaction> getAllTransactions() {
    final box = _hiveService.transactionsBox;
    return box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> getRecentTransactions({int limit = 5}) {
    final allTransactions = getAllTransactions();
    return allTransactions.take(limit).toList();
  }

  List<Transaction> getTransactionsByCategory(String category) {
    final allTransactions = getAllTransactions();
    return allTransactions
        .where((transaction) => transaction.category == category)
        .toList();
  }

  double getTotalIncome() {
    final allTransactions = getAllTransactions();
    return allTransactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double getTotalExpenses() {
    final allTransactions = getAllTransactions();
    return allTransactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double getCurrentBalance() {
    return getTotalIncome() - getTotalExpenses();
  }

  Map<String, double> getExpensesByCategory() {
    final expenses = getAllTransactions()
        .where((transaction) => transaction.type == TransactionType.expense);

    final Map<String, double> categoryTotals = {};

    for (final expense in expenses) {
      categoryTotals.update(
        expense.category,
            (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return categoryTotals;
  }
}