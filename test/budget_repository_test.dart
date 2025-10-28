import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pre_dashboard/core/models/budget.dart';
import 'package:pre_dashboard/core/models/transaction.dart';
import 'package:pre_dashboard/data/repositories/budget_repository.dart';
import 'package:pre_dashboard/data/repositories/transaction_repository.dart';
import 'package:pre_dashboard/data/local_storage/hive_service.dart';

class MockHiveService extends Mock implements HiveService {}
class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockBox extends Mock implements Box<Budget> {}

void main() {
  late MockHiveService mockHiveService;
  late MockTransactionRepository mockTransactionRepository;
  late MockBox mockBox;
  late BudgetRepository repository;

  setUp(() {
    mockHiveService = MockHiveService();
    mockTransactionRepository = MockTransactionRepository();
    mockBox = MockBox();
    repository = BudgetRepository(mockHiveService, mockTransactionRepository);

    when(() => mockHiveService.budgets).thenReturn(mockBox);
  });

  group('BudgetRepository', () {
    final testBudget = Budget(
      category: 'Food',
      amount: 1000.0,
      month: DateTime(2024, 1),
    );

    test('setBudget should put budget in box', () async {
      when(() => mockBox.put(any(), testBudget))
          .thenAnswer((_) async => {});

      await repository.setBudget(testBudget);

      verify(() => mockBox.put(any(), testBudget)).called(1);
    });

    test('getBudget should return correct budget', () {
      when(() => mockBox.get(any())).thenReturn(testBudget);

      final result = repository.getBudget('Food', DateTime(2024, 1));

      expect(result, testBudget);
    });

    test('getAllBudgetsForMonth should filter correctly', () {
      final budgets = [
        testBudget,
        testBudget.copyWith(category: 'Travel'),
        testBudget.copyWith(month: DateTime(2024, 2)), // Different month
      ];

      when(() => mockBox.values).thenReturn(budgets);

      final result = repository.getAllBudgetsForMonth(DateTime(2024, 1));

      expect(result.length, 2);
      expect(result.containsKey('Food'), true);
      expect(result.containsKey('Travel'), true);
    });

    test('getBudgetUsagePercentage should calculate correctly', () {
      final transactions = [
        Transaction(
          id: '1',
          title: 'Food',
          amount: 300.0,
          type: TransactionType.expense,
          category: 'Food',
          date: DateTime(2024, 1, 15),
        ),
      ];

      when(() => mockBox.get(any())).thenReturn(testBudget);
      when(() => mockTransactionRepository.getAllTransactions()).thenReturn(transactions);

      final percentage = repository.getBudgetUsagePercentage(
          'Food',
          DateTime(2024, 1),
          transactions
      );

      expect(percentage, 30.0); // 300/1000 = 30%
    });

    test('isCategoryOverBudget should return true when over budget', () {
      final transactions = [
        Transaction(
          id: '1',
          title: 'Food',
          amount: 1200.0, // Over budget
          type: TransactionType.expense,
          category: 'Food',
          date: DateTime(2024, 1, 15),
        ),
      ];

      when(() => mockBox.get(any())).thenReturn(testBudget);
      when(() => mockTransactionRepository.getAllTransactions()).thenReturn(transactions);

      final isOverBudget = repository.isCategoryOverBudget(
          'Food',
          DateTime(2024, 1),
          transactions
      );

      expect(isOverBudget, true);
    });
  });
}