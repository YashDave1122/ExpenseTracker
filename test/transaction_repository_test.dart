import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:pre_dashboard/core/models/transaction.dart';
import 'package:pre_dashboard/data/repositories/transaction_repository.dart';
import 'package:pre_dashboard/data/local_storage/hive_service.dart';

// Mock classes
class MockHiveService extends Mock implements HiveService {}
class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late MockHiveService mockHiveService;
  late MockBox<Transaction> mockBox;
  late TransactionRepository repository;

  setUp(() {
    mockHiveService = MockHiveService();
    mockBox = MockBox<Transaction>();
    repository = TransactionRepository(mockHiveService);

    when(() => mockHiveService.transactions).thenReturn(mockBox);
  });

  group('TransactionRepository', () {
    final testTransaction = Transaction(
      id: '1',
      title: 'Test Transaction',
      amount: 100.0,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime.now(),
    );

    test('addTransaction should put transaction in box', () async {
      when(() => mockBox.put(testTransaction.id, testTransaction))
          .thenAnswer((_) async {});

      await repository.addTransaction(testTransaction);

      verify(() => mockBox.put(testTransaction.id, testTransaction)).called(1);
    });

    test('getAllTransactions should return sorted list', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final transactions = [
        testTransaction.copyWith(id: '1', date: yesterday),
        testTransaction.copyWith(id: '2', date: now),
      ];

      when(() => mockBox.values).thenReturn(transactions);

      final result = repository.getAllTransactions();

      expect(result.length, 2);
      expect(result.first.id, '2'); // Most recent first
      expect(result.last.id, '1');
    });

    test('getCurrentBalance should calculate correctly', () {
      final transactions = [
        testTransaction.copyWith(id: '1', type: TransactionType.income, amount: 200),
        testTransaction.copyWith(id: '2', type: TransactionType.expense, amount: 100),
      ];

      when(() => mockBox.values).thenReturn(transactions);

      final balance = repository.getCurrentBalance();

      expect(balance, 100.0);
    });

    test('deleteTransaction should remove from box', () async {
      when(() => mockBox.delete('1')).thenAnswer((_) async {});

      await repository.deleteTransaction('1');

      verify(() => mockBox.delete('1')).called(1);
    });

    test('getExpensesByCategory should group correctly', () {
      final transactions = [
        testTransaction.copyWith(id: '1', category: 'Food', amount: 50),
        testTransaction.copyWith(id: '2', category: 'Food', amount: 30),
        testTransaction.copyWith(id: '3', category: 'Travel', amount: 100),
      ];

      when(() => mockBox.values).thenReturn(transactions);

      final result = repository.getExpensesByCategory();

      expect(result['Food'], 80.0);
      expect(result['Travel'], 100.0);
    });
  });
}