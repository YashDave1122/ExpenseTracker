import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';
import '../../core/models/budget.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/formatters.dart';

class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});

  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen> {
  final _amountControllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing budget values
    final budgets = ref.read(budgetsProvider);
    for (final category in AppConstants.categories) {
      _amountControllers[category] = TextEditingController(
        text: budgets[category]?.amount.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _amountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final budgets = ref.watch(budgetsProvider);
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Budgets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Set Monthly Budgets',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set budget limits for each category. You\'ll get alerts when you\'re close to or over your budget.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          ...AppConstants.categories.map((category) =>
              _BudgetCard(
                category: category,
                amountController: _amountControllers[category]!,
                currentSpent: ref.read(budgetsProvider.notifier).getCategorySpentAmount(category),
                budget: budgets[category],
                isOverBudget: ref.read(budgetsProvider.notifier).isCategoryOverBudget(category),
                isCloseToBudget: ref.read(budgetsProvider.notifier).isCategoryCloseToBudget(category),
                onSave: (amount) => _saveBudget(category, amount),
              ),
          ),
        ],
      ),
    );
  }

  void _saveBudget(String category, double amount) {
    final budget = Budget(
      category: category,
      amount: amount,
      month: DateTime.now(),
    );

    ref.read(budgetsProvider.notifier).setBudget(budget);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Budget for $category updated')),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final String category;
  final TextEditingController amountController;
  final double currentSpent;
  final Budget? budget;
  final bool isOverBudget;
  final bool isCloseToBudget;
  final Function(double) onSave;

  const _BudgetCard({
    required this.category,
    required this.amountController,
    required this.currentSpent,
    this.budget,
    required this.isOverBudget,
    required this.isCloseToBudget,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final hasBudget = budget != null;
    final percentage = hasBudget ? (currentSpent / budget!.amount) * 100 : 0;

    Color getStatusColor() {
      if (isOverBudget) return Colors.red;
      if (isCloseToBudget) return Colors.orange;
      return Colors.green;
    }

    String getStatusText() {
      if (isOverBudget) return 'Over Budget';
      if (isCloseToBudget) return 'Close to Budget';
      if (hasBudget) return 'On Track';
      return 'No Budget Set';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(AppConstants.categoryIcons[category] ?? '📦'),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: getStatusColor()),
                  ),
                  child: Text(
                    getStatusText(),
                    style: TextStyle(
                      color: getStatusColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasBudget) ...[
              LinearProgressIndicator(
                value: percentage > 1 ? 1 : percentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(getStatusColor()),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${percentage.toStringAsFixed(1)}% used',
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${Formatters.formatCurrency(currentSpent)} / ${Formatters.formatCurrency(budget!.amount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Monthly Budget',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text);
                    if (amount != null && amount > 0) {
                      onSave(amount);
                    }
                  },
                  child: const Text('Set'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}