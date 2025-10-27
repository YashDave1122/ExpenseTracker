// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import '../../core/models/transaction.dart';
// import '../../core/models/budget.dart';
//
// class HiveService {
//   static const String transactionsBox = 'transactions';
//   static const String budgetsBox = 'budgets';
//
//   static Future<void> init() async {
//     final appDocumentDir = await getApplicationDocumentsDirectory();
//     Hive.init(appDocumentDir.path);
//
//     // Register adapters
//     Hive.registerAdapter(TransactionAdapter());
//     Hive.registerAdapter(TransactionTypeAdapter());
//     Hive.registerAdapter(BudgetAdapter());
//
//     // Open boxes
//     await Hive.openBox<Transaction>(transactionsBox);
//     await Hive.openBox<Budget>(budgetsBox);
//   }
//
//   Box<Transaction> get transactionsBox => Hive.box<Transaction>(transactionsBox);
//   Box<Budget> get budgetsBox => Hive.box<Budget>(budgetsBox);
// }
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/models/transaction.dart';
import '../../core/models/budget.dart';

class HiveService {
  // Use different names for static constants
  static const String _transactionsBoxName = 'transactions';
  static const String _budgetsBoxName = 'budgets';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register adapters
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(BudgetAdapter());

    // Open boxes
    await Hive.openBox<Transaction>(_transactionsBoxName);
    await Hive.openBox<Budget>(_budgetsBoxName);
  }

  // Instance methods with different names
  Box<Transaction> get transactionsBox => Hive.box<Transaction>(_transactionsBoxName);
  Box<Budget> get budgetsBox => Hive.box<Budget>(_budgetsBoxName);
}