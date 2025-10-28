import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_dashboard/app/app.dart';
import 'package:pre_dashboard/main.dart';
import 'package:pre_dashboard/features/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('App starts with dashboard screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Expense Tracker'), findsOneWidget);
  });

  testWidgets('App has proper theme', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme, isNotNull);
    expect(materialApp.darkTheme, isNotNull);
  });
}