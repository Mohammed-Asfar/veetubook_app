import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/db/app_database.dart';
import '../../../core/utils/money.dart';
import '../../expenses/domain/expenses_repository.dart';

/// Backup/export and destructive data operations for the Settings screen.
///
/// PRD: on-device data can be lost on uninstall, so offer a manual CSV export
/// as a backup path before cloud sync exists; destructive clear requires the
/// caller to confirm first.
class DataManagementService {
  DataManagementService(this._db, this._expenses);

  final AppDatabase _db;
  final ExpensesRepository _expenses;

  /// Writes all expenses to a CSV file and opens the share sheet. Returns the
  /// file path written.
  Future<String> exportExpensesCsv() async {
    final expenses = await _expenses.watchExpenses().first;
    final dateFmt = DateFormat('yyyy-MM-dd');

    final rows = <List<dynamic>>[
      ['Date', 'List', 'Total (₹)'],
      for (final e in expenses)
        [
          dateFmt.format(e.date.toLocal()),
          e.listTitle ?? '',
          Money.paiseToRupees(e.totalPaise).toString(),
        ],
    ];

    final csvText = Csv().encode(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'veetubook_expenses.csv'));
    await file.writeAsString(csvText);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'veetubook expenses export',
      ),
    );
    return file.path;
  }

  /// Deletes all user data. Caller must confirm first.
  Future<void> clearAllData() => _db.clearAllData();
}
