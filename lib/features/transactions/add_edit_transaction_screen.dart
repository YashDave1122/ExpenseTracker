// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../app/providers.dart';
// import '../../core/models/transaction.dart';
// import '../../core/utils/constants.dart';
// import '../../core/utils/formatters.dart';
// import '../../core/widgets/amount_input_field.dart';
//
// import '../../core/widgets/category_chips.dart';
//
// class AddEditTransactionScreen extends ConsumerStatefulWidget {
//   final Transaction? transaction;
//
//   const AddEditTransactionScreen({super.key, this.transaction});
//
//   @override
//   ConsumerState<AddEditTransactionScreen> createState() => _AddEditTransactionScreenState();
// }
//
// class _AddEditTransactionScreenState extends ConsumerState<AddEditTransactionScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _notesController = TextEditingController();
//
//   TransactionType _selectedType = TransactionType.expense;
//   String _selectedCategory = AppConstants.categories.first;
//   DateTime _selectedDate = DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.transaction != null) {
//       _titleController.text = widget.transaction!.title;
//       _amountController.text = widget.transaction!.amount.toString();
//       _notesController.text = widget.transaction!.notes ?? '';
//       _selectedType = widget.transaction!.type;
//       _selectedCategory = widget.transaction!.category;
//       _selectedDate = widget.transaction!.date;
//     }
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _amountController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.transaction == null ? 'Add Transaction' : 'Edit Transaction'),
//         actions: [
//           if (widget.transaction != null) ...[
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: _deleteTransaction,
//             ),
//           ],
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Transaction Type Selection
//               _buildTypeSelector(),
//
//               const SizedBox(height: 16),
//
//               // Title Field
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Title',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//
//               const SizedBox(height: 16),
//
//               // Amount Field
//               AmountInputField(controller: _amountController),
//
//               const SizedBox(height: 16),
//
//               // Category Selection
//               _buildCategorySelector(),
//
//               const SizedBox(height: 16),
//
//               // Date Picker
//               _buildDatePicker(),
//
//               const SizedBox(height: 16),
//
//               // Notes Field
//               TextFormField(
//                 controller: _notesController,
//                 decoration: InputDecoration(
//                   labelText: 'Notes (optional)',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 maxLines: 3,
//               ),
//
//               const SizedBox(height: 32),
//
//               // Save Button
//               ElevatedButton(
//                 onPressed: _saveTransaction,
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(widget.transaction == null ? 'Add Transaction' : 'Update Transaction'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTypeSelector() {
//     return SegmentedButton<TransactionType>(
//       segments: const [
//         ButtonSegment<TransactionType>(
//           value: TransactionType.income,
//           label: Text('Income'),
//           icon: Icon(Icons.arrow_upward),
//         ),
//         ButtonSegment<TransactionType>(
//           value: TransactionType.expense,
//           label: Text('Expense'),
//           icon: Icon(Icons.arrow_downward),
//         ),
//       ],
//       selected: <TransactionType>{_selectedType},
//       onSelectionChanged: (Set<TransactionType> newSelection) {
//         setState(() {
//           _selectedType = newSelection.first;
//         });
//       },
//     );
//   }
//
//   Widget _buildCategorySelector() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Category',
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: AppConstants.categories.map((category) {
//             return CategoryChip(
//               category: category,
//               isSelected: _selectedCategory == category,
//               onTap: () => setState(() => _selectedCategory = category),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDatePicker() {
//     return Row(
//       children: [
//         Text(
//           'Date: ${Formatters.formatDate(_selectedDate)}',
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//         const Spacer(),
//         TextButton(
//           onPressed: _pickDate,
//           child: const Text('Change Date'),
//         ),
//       ],
//     );
//   }
//
//   void _pickDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   void _saveTransaction() {
//     if (_formKey.currentState!.validate()) {
//       final transaction = Transaction(
//         id: widget.transaction?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//         title: _titleController.text.trim(),
//         amount: double.parse(_amountController.text),
//         type: _selectedType,
//         category: _selectedCategory,
//         date: _selectedDate,
//         notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
//       );
//
//       if (widget.transaction == null) {
//         ref.read(transactionsProvider.notifier).addTransaction(transaction);
//       } else {
//         ref.read(transactionsProvider.notifier).updateTransaction(transaction);
//       }
//
//       Navigator.pop(context);
//     }
//   }
//
//   void _deleteTransaction() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Transaction'),
//         content: const Text('Are you sure you want to delete this transaction?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               ref.read(transactionsProvider.notifier).deleteTransaction(widget.transaction!.id);
//               Navigator.popUntil(context, (route) => route.isFirst);
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pre_dashboard/core/widgets/category_chips.dart';
import '../../app/providers.dart';
import '../../core/models/transaction.dart';
import '../../core/utils/constants.dart';
import '../../core/widgets/amount_input_field.dart';


class AddEditTransactionScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;

  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  ConsumerState<AddEditTransactionScreen> createState() => _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = AppConstants.expenseCategories.first;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _notesController.text = widget.transaction!.notes ?? '';
      _selectedType = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
      _selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null ? 'Add Transaction' : 'Edit Transaction'),
        actions: [
          if (widget.transaction != null) ...[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTransaction,
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Transaction Type Selection
              _buildTypeSelector(),

              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: _selectedType == TransactionType.income ? 'Income Source' : 'Expense Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _selectedType == TransactionType.income
                        ? 'Please enter income source'
                        : 'Please enter a title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Amount Field
              AmountInputField(controller: _amountController),

              const SizedBox(height: 16),

              // Category Selection - FIXED: Different categories for income/expense
              _buildCategorySelector(),

              const SizedBox(height: 16),

              // Date Picker
              _buildDatePicker(),

              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Save Button
              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(widget.transaction == null ? 'Add Transaction' : 'Update Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SegmentedButton<TransactionType>(
      segments: const [
        ButtonSegment<TransactionType>(
          value: TransactionType.income,
          label: Text('Income'),
          icon: Icon(Icons.arrow_upward),
        ),
        ButtonSegment<TransactionType>(
          value: TransactionType.expense,
          label: Text('Expense'),
          icon: Icon(Icons.arrow_downward),
        ),
      ],
      selected: <TransactionType>{_selectedType},
      onSelectionChanged: (Set<TransactionType> newSelection) {
        setState(() {
          _selectedType = newSelection.first;
          // Reset category to first item of new type - FIXED
          final categories = AppConstants.getCategoriesForType(_selectedType);
          _selectedCategory = categories.first;
        });
      },
    );
  }

  Widget _buildCategorySelector() {
    final categories = AppConstants.getCategoriesForType(_selectedType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedType == TransactionType.income ? 'Income Category' : 'Expense Category',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            return CategoryChip(
              category: category,
              isSelected: _selectedCategory == category,
              onTap: () => setState(() => _selectedCategory = category),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        Text(
          'Date: ${_formatDate(_selectedDate)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        TextButton(
          onPressed: _pickDate,
          child: const Text('Change Date'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        id: widget.transaction?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        type: _selectedType,
        category: _selectedCategory,
        date: _selectedDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      // FIXED: Use proper state update that refreshes the UI immediately
      if (widget.transaction == null) {
        ref.read(transactionsProvider.notifier).addTransaction(transaction);
      } else {
        ref.read(transactionsProvider.notifier).updateTransaction(transaction);
      }

      // FIXED: Navigate back and show success message
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.transaction == null
              ? 'Transaction added successfully!'
              : 'Transaction updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteTransaction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(transactionsProvider.notifier).deleteTransaction(widget.transaction!.id);
              Navigator.popUntil(context, (route) => route.isFirst);

              // Show delete success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}