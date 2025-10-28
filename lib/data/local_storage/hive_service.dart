
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/models/transaction.dart';
import '../../core/models/budget.dart';

class HiveService {
  static const String transactionsBox = 'transactions';
  static const String budgetsBox = 'budgets';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register adapters
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(BudgetAdapter());

    // Open boxes
    await Hive.openBox<Transaction>(transactionsBox);
    await Hive.openBox<Budget>(budgetsBox);
  }

  Box<Transaction> get transactions => Hive.box<Transaction>(transactionsBox);
  Box<Budget> get budgets => Hive.box<Budget>(budgetsBox);
}