import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_dashboard/app/providers.dart';
import '../../../core/models/transaction.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/constants.dart';

class TransactionTile extends ConsumerWidget {
  final Transaction transaction;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIncome = transaction.type == TransactionType.income;
    final budgets = ref.watch(budgetsProvider);
    final isOverBudget = ref.read(budgetsProvider.notifier).isCategoryOverBudget(transaction.category);
    final isCloseToBudget = ref.read(budgetsProvider.notifier).isCategoryCloseToBudget(transaction.category);

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Transaction'),
            content: const Text('Are you sure you want to delete this transaction?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isIncome ? Colors.green.shade100 : Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
          title: Text(transaction.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Formatters.formatDate(transaction.date)),
              Row(
                children: [
                  Text(AppConstants.categoryIcons[transaction.category] ?? '📦'),
                  const SizedBox(width: 4),
                  Text(transaction.category),
                  if (isOverBudget && !isIncome) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'OVER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else if (isCloseToBudget && !isIncome) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'CLOSE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          trailing: Text(
            '${isIncome ? '+' : '-'}${Formatters.formatCurrency(transaction.amount)}',
            style: TextStyle(
              color: isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}