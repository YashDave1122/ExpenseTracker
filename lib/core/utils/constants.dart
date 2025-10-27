class AppConstants {
  static const List<String> categories = [
    'Food',
    'Travel',
    'Bills',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Education',
    'Other'
  ];

  static const Map<String, String> categoryIcons = {
    'Food': '🍕',
    'Travel': '✈️',
    'Bills': '📄',
    'Shopping': '🛍️',
    'Entertainment': '🎬',
    'Healthcare': '🏥',
    'Education': '📚',
    'Other': '📦',
  };

  static const List<String> colors = [
    '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
    '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
  ];
}

class AppRoutes {
  static const String dashboard = '/';
  static const String transactions = '/transactions';
  static const String addTransaction = '/add-transaction';
  static const String editTransaction = '/edit-transaction';
  static const String budgets = '/budgets';
}