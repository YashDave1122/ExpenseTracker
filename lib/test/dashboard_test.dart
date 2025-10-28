import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_dashboard/features/dashboard/dashboard_screen.dart';
import 'package:pre_dashboard/core/models/transaction.dart';

void main() {
  testWidgets('Dashboard screen displays balance card', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    expect(find.text('Current Balance'), findsOneWidget);
    expect(find.text('₹ 0.00'), findsOneWidget);
  });

  testWidgets('Dashboard screen displays summary cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
  });

  testWidgets('Dashboard shows empty state when no transactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(find.text('Add your first transaction to get started'), findsOneWidget);
  });

  testWidgets('Floating action button is present', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}