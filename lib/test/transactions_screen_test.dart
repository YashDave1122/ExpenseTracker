import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_dashboard/features/transactions/transactions_screen.dart';
import 'package:pre_dashboard/core/models/transaction.dart';

void main() {
  testWidgets('Transactions screen shows empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TransactionsScreen(),
        ),
      ),
    );

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(find.text('Add your first transaction to get started'), findsOneWidget);
  });

  testWidgets('Transactions screen has add button in app bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TransactionsScreen(),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Add transaction button navigates to add screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const TransactionsScreen(),
          routes: {
            '/add-transaction': (context) => Scaffold(body: Text('Add Transaction Screen')),
          },
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add Transaction Screen'), findsOneWidget);
  });
}