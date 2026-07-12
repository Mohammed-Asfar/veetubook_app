import 'entities/expense.dart';
import 'entities/monthly_summary.dart';

/// Repository interface for expenses / trip history and monthly analytics.
abstract interface class ExpensesRepository {
  /// Reactive stream of all expenses, most recent first, with the list title
  /// joined in for display.
  Stream<List<Expense>> watchExpenses();

  /// Finish a shopping trip: atomically (in one transaction) mark the list
  /// completed and create/refresh its expense record from the bought-items
  /// total. Returns the expense id. Idempotent per list (re-finishing updates
  /// the existing expense rather than duplicating).
  Future<int> finishTrip(int listId);

  /// Monthly totals bucketed by local month, most recent first (for M4).
  Stream<List<MonthlySummary>> watchMonthlySummaries();
}
