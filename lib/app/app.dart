
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/transactions/transactions_screen.dart';
import '../features/transactions/add_edit_transaction_screen.dart';
import '../features/budgets/budgets_screen.dart';
import '../core/models/transaction.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/transactions': (context) => const TransactionsScreen(),
        '/add-transaction': (context) => const AddEditTransactionScreen(),
        '/edit-transaction': (context) {
          final transaction = ModalRoute.of(context)!.settings.arguments as Transaction;
          return AddEditTransactionScreen(transaction: transaction);
        },
        '/budgets': (context) => const BudgetsScreen(),
      },
    );
  }
}