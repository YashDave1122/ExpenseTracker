//
// import 'package:pre_dashboard/core/models/transaction.dart';
//
// class AppConstants {
//   // Expense Categories
//   static const List<String> expenseCategories = [
//     'Food',
//     'Travel',
//     'Bills',
//     'Shopping',
//     'Entertainment',
//     'Healthcare',
//     'Education',
//     'Other'
//   ];
//
//   // Income Categories
//   static const List<String> incomeCategories = [
//     'Salary',
//     'Freelance',
//     'Investments',
//     'Business',
//     'Gifts',
//     'Rental Income',
//     'Bonus',
//     'Other Income'
//   ];
//
//   // All categories (for backward compatibility if needed)
//   static const List<String> categories = [
//     'Food',
//     'Travel',
//     'Bills',
//     'Shopping',
//     'Entertainment',
//     'Healthcare',
//     'Education',
//     'Other'
//   ];
//
//   static const Map<String, String> categoryIcons = {
//     // Expense Icons
//     'Food': '🍕',
//     'Travel': '✈️',
//     'Bills': '📄',
//     'Shopping': '🛍️',
//     'Entertainment': '🎬',
//     'Healthcare': '🏥',
//     'Education': '📚',
//     'Other': '📦',
//
//     // Income Icons
//     'Salary': '💰',
//     'Freelance': '💼',
//     'Investments': '📈',
//     'Business': '🏢',
//     'Gifts': '🎁',
//     'Rental Income': '🏠',
//     'Bonus': '⭐',
//     'Other Income': '💸',
//   };
//
//   static const List<String> colors = [
//     '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
//     '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
//   ];
//
//   // Helper method to get categories based on transaction type
//   static List<String> getCategoriesForType(TransactionType type) {
//     return type == TransactionType.income ? incomeCategories : expenseCategories;
//   }
// }
//
// class AppRoutes {
//   static const String dashboard = '/';
//   static const String transactions = '/transactions';
//   static const String addTransaction = '/add-transaction';
//   static const String editTransaction = '/edit-transaction';
//   static const String budgets = '/budgets';
// }
import 'package:pre_dashboard/core/models/transaction.dart';

class AppConstants {
  // Expense Categories
  static const List<String> expenseCategories = [
    'Food',
    'Travel',
    'Bills',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Education',
    'Other'
  ];

  // Income Categories
  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investments',
    'Business',
    'Gifts',
    'Rental Income',
    'Bonus',
    'Other Income'
  ];

  static const Map<String, String> categoryIcons = {
    // Expense Icons
    'Food': '🍕',
    'Travel': '✈️',
    'Bills': '📄',
    'Shopping': '🛍️',
    'Entertainment': '🎬',
    'Healthcare': '🏥',
    'Education': '📚',
    'Other': '📦',

    // Income Icons
    'Salary': '💰',
    'Freelance': '💼',
    'Investments': '📈',
    'Business': '🏢',
    'Gifts': '🎁',
    'Rental Income': '🏠',
    'Bonus': '⭐',
    'Other Income': '💸',
  };

  static const List<String> colors = [
    '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
    '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
  ];

  // Helper method to get categories based on transaction type
  static List<String> getCategoriesForType(TransactionType type) {
    return type == TransactionType.income ? incomeCategories : expenseCategories;
  }
}

class AppRoutes {
  static const String dashboard = '/';
  static const String transactions = '/transactions';
  static const String addTransaction = '/add-transaction';
  static const String editTransaction = '/edit-transaction';
  static const String budgets = '/budgets';
}