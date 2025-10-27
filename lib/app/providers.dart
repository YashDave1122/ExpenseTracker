import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/models/transaction.dart';
import '../core/models/budget.dart';
import '../data/local_storage/hive_service.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/repositories/budget_repository.dart';

// Providers
final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return TransactionRepository(hiveService);
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return BudgetRepository(hiveService);
});

// State Providers
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionsNotifier(repository);
});

final budgetsProvider = StateNotifierProvider<BudgetsNotifier, Map<String, Budget>>((ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  return BudgetsNotifier(repository, transactionRepository);
});

// Notifiers
class TransactionsNotifier extends StateNotifier<List<Transaction>> {
  final TransactionRepository _repository;

  TransactionsNotifier(this._repository) : super(_repository.getAllTransactions());

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.addTransaction(transaction);
    state = _repository.getAllTransactions();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _repository.updateTransaction(transaction);
    state = _repository.getAllTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    state = _repository.getAllTransactions();
  }

  void refresh() {
    state = _repository.getAllTransactions();
  }
}

class BudgetsNotifier extends StateNotifier<Map<String, Budget>> {
  final BudgetRepository _repository;
  final TransactionRepository _transactionRepository;

  BudgetsNotifier(this._repository, this._transactionRepository)
      : super(_repository.getAllBudgetsForMonth(DateTime.now()));

  Future<void> setBudget(Budget budget) async {
    await _repository.setBudget(budget);
    state = _repository.getAllBudgetsForMonth(DateTime.now());
  }

  void refresh() {
    state = _repository.getAllBudgetsForMonth(DateTime.now());
  }

  double getCategorySpentAmount(String category) {
    final transactions = _transactionRepository.getAllTransactions();
    return _repository.getCategorySpentAmount(category, DateTime.now(), transactions);
  }

  double getBudgetUsagePercentage(String category) {
    final transactions = _transactionRepository.getAllTransactions();
    return _repository.getBudgetUsagePercentage(category, DateTime.now(), transactions);
  }

  bool isCategoryOverBudget(String category) {
    final transactions = _transactionRepository.getAllTransactions();
    return _repository.isCategoryOverBudget(category, DateTime.now(), transactions);
  }

  bool isCategoryCloseToBudget(String category) {
    final transactions = _transactionRepository.getAllTransactions();
    return _repository.isCategoryCloseToBudget(category, DateTime.now(), transactions);
  }
}

// Derived Providers
final currentBalanceProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getCurrentBalance();
});

final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getRecentTransactions(limit: 5);
});

final expensesByCategoryProvider = Provider<Map<String, double>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getExpensesByCategory();
});

final totalIncomeProvider = Provider<double>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTotalIncome();
});

final totalExpensesProvider = Provider<double>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTotalExpenses();
});