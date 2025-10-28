import 'package:hive/hive.dart';
import 'package:pre_dashboard/core/utils/constants.dart';
import 'package:pre_dashboard/data/repositories/transaction_repository.dart';
import '../../core/models/budget.dart';
import '../../core/models/transaction.dart';
import '../local_storage/hive_service.dart';


class BudgetRepository {
  final HiveService _hiveService;
  final TransactionRepository _transactionRepository;

  // FIXED: Constructor now accepts 2 parameters
  BudgetRepository(this._hiveService, this._transactionRepository);

  Future<void> setBudget(Budget budget) async {
    // Only allow expense categories for budgets
    if (!AppConstants.expenseCategories.contains(budget.category)) {
      throw Exception('Budgets can only be set for expense categories');
    }

    final box = _hiveService.budgets;
    final key = '${budget.category}_${budget.month.month}_${budget.month.year}';
    await box.put(key, budget);
  }

  Budget? getBudget(String category, DateTime month) {
    final box = _hiveService.budgets;
    final key = '${category}_${month.month}_${month.year}';
    return box.get(key);
  }

  Map<String, Budget> getAllBudgetsForMonth(DateTime month) {
    final box = _hiveService.budgets;
    final budgets = <String, Budget>{};

    for (final budget in box.values) {
      if (budget.month.month == month.month && budget.month.year == month.year) {
        budgets[budget.category] = budget;
      }
    }

    return budgets;
  }

  double getCategorySpentAmount(String category, DateTime month, List<Transaction> transactions) {
    return transactions
        .where((transaction) =>
    transaction.category == category &&
        transaction.type == TransactionType.expense &&
        transaction.date.month == month.month &&
        transaction.date.year == month.year)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  double getBudgetUsagePercentage(String category, DateTime month, List<Transaction> transactions) {
    final budget = getBudget(category, month);
    if (budget == null) return 0.0;

    final spent = getCategorySpentAmount(category, month, transactions);
    return (spent / budget.amount) * 100;
  }

  bool isCategoryOverBudget(String category, DateTime month, List<Transaction> transactions) {
    return getBudgetUsagePercentage(category, month, transactions) > 100;
  }

  bool isCategoryCloseToBudget(String category, DateTime month, List<Transaction> transactions) {
    final percentage = getBudgetUsagePercentage(category, month, transactions);
    return percentage >= 80 && percentage <= 100;
  }
}