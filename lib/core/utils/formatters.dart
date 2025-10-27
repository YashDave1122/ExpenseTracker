import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat monthFormat = DateFormat('MMMM yyyy');
  static final NumberFormat currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 2,
  );

  static String formatDate(DateTime date) {
    return dateFormat.format(date);
  }

  static String formatCurrency(double amount) {
    return currencyFormat.format(amount);
  }

  static String formatMonth(DateTime date) {
    return monthFormat.format(date);
  }
}