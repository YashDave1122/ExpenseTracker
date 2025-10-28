import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pre_dashboard/core/models/transaction.dart';
import 'package:pre_dashboard/data/repositories/transaction_repository.dart';
import 'package:pre_dashboard/app/providers.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockTransactionRepository mockRepository;
  late TransactionsNotifier notifier;

  setUp(() {
    mockRepository = MockTransactionRepository();
    notifier = TransactionsNotifier(mockRepository);
  });

  test('initial state should be empty list', () {
    when(() => mockRepository.getAllTransactions()).thenReturn([]);

    expect(notifier.state, isEmpty);
  });

  test('addTransaction should update state', () async {
    final transaction = Transaction(
      id: '1',
      title: 'Test',
      amount: 100,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime.now(),
    );

    when(() => mockRepository.addTransaction(transaction))
        .thenAnswer((_) async => {});
    when(() => mockRepository.getAllTransactions())
        .thenReturn([transaction]);

    await notifier.addTransaction(transaction);

    expect(notifier.state.length, 1);
    expect(notifier.state.first.id, '1');
  });

  test('deleteTransaction should remove transaction', () async {
    final transaction = Transaction(
      id: '1',
      title: 'Test',
      amount: 100,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime.now(),
    );

    when(() => mockRepository.deleteTransaction('1'))
        .thenAnswer((_) async => {});
    when(() => mockRepository.getAllTransactions())
        .thenReturn([]);

    await notifier.deleteTransaction('1');

    expect(notifier.state, isEmpty);
  });

  test('updateTransaction should modify existing transaction', () async {
    final originalTransaction = Transaction(
      id: '1',
      title: 'Original',
      amount: 100,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime.now(),
    );

    final updatedTransaction = Transaction(
      id: '1',
      title: 'Updated',
      amount: 150,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime.now(),
    );

    when(() => mockRepository.updateTransaction(updatedTransaction))
        .thenAnswer((_) async => {});
    when(() => mockRepository.getAllTransactions())
        .thenReturn([updatedTransaction]);

    await notifier.updateTransaction(updatedTransaction);

    expect(notifier.state.length, 1);
    expect(notifier.state.first.title, 'Updated');
    expect(notifier.state.first.amount, 150);
  });
}