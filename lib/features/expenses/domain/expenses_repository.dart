import '../../../core/utils/month_utils.dart';
import 'entities/expense.dart';
import 'entities/monthly_summary.dart';

/// Repository interface for expenses / trip history and monthly analytics.
abstract interface class ExpensesRepository {
  /// Reactive stream of all expenses, most recent first, with the list title
  /// joined in for display.
  Stream<List<Expense>> watchExpenses();

  /// Keep the list's expense in sync with its bought-items total. Called
  /// automatically as items change: upserts the expense when the bought total
  /// is > 0, or removes it when the total is 0. Idempotent per list.
  Future<void> syncExpenseForList(int listId);

  /// Monthly totals bucketed by local month, most recent first (for M4).
  Stream<List<MonthlySummary>> watchMonthlySummaries();

  /// Per-day spend (paise) for every day of [month], indexed by day-of-month
  /// (1..daysInMonth). Days with no spend are 0. Used by the daily chart.
  Stream<List<int>> watchDailyTotals(YearMonth month);
}
