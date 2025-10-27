import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_dashboard/core/widgets/balance_card.dart';
import 'package:pre_dashboard/core/widgets/expense_chart.dart';
import 'package:pre_dashboard/core/widgets/recent_transactions_list.dart';
import 'package:pre_dashboard/core/widgets/summary_cards.dart';
import '../../app/providers.dart';
import '../../core/utils/formatters.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(transactionsProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              BalanceCard(balance: currentBalance),

              const SizedBox(height: 24),

              // Summary Cards
              SummaryCards(
                totalIncome: totalIncome,
                totalExpenses: totalExpenses,
              ),

              const SizedBox(height: 24),

              // Expense Chart
              ExpenseChart(expensesByCategory: expensesByCategory),

              const SizedBox(height: 24),

              // Recent Transactions
              RecentTransactionsList(transactions: recentTransactions),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}