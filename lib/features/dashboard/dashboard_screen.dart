
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_dashboard/core/widgets/balance_card.dart';
import 'package:pre_dashboard/core/widgets/recent_transactions_list.dart';
import 'package:pre_dashboard/core/widgets/summary_cards.dart';
import '../../app/providers.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/expense_chart.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIXED: These will now update in real-time when transactions change
    final transactions = ref.watch(transactionsProvider);
    final currentBalance = ref.watch(currentBalanceProvider);
    final recentTransactions = ref.watch(recentTransactionsProvider);
    final totalIncome = ref.watch(totalIncomeProvider);
    final totalExpenses = ref.watch(totalExpensesProvider);
    final expensesByCategory = ref.watch(expensesByCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Manual refresh
              ref.read(transactionsProvider.notifier).refresh();
              ref.read(budgetsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // FIXED: Proper refresh that updates UI
          ref.read(transactionsProvider.notifier).refresh();
          ref.read(budgetsProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card - Updates in real-time
              BalanceCard(balance: currentBalance),

              const SizedBox(height: 24),

              // Summary Cards - Updates in real-time
              SummaryCards(
                totalIncome: totalIncome,
                totalExpenses: totalExpenses,
              ),

              const SizedBox(height: 24),

              // Expense Chart - Updates in real-time
              ExpenseChart(expensesByCategory: expensesByCategory),

              const SizedBox(height: 24),

              // Recent Transactions - Updates in real-time
              RecentTransactionsList(transactions: recentTransactions),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction').then((_) {
            // FIXED: Refresh data when returning from add transaction
            ref.read(transactionsProvider.notifier).refresh();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}