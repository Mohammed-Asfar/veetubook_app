import '../../../core/utils/month_utils.dart';
import '../domain/entities/expense.dart';
import '../domain/entities/monthly_summary.dart';
import '../domain/expenses_repository.dart';
import 'expenses_dao.dart';

/// SQLite-backed implementation of [ExpensesRepository].
class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl(this._dao);

  final ExpensesDao _dao;

  @override
  Stream<List<Expense>> watchExpenses() {
    return _dao.watchExpensesWithTitle().map(
          (rows) => rows
              .map((r) => Expense(
                    id: r.expense.id,
                    listId: r.expense.listId,
                    date: r.expense.date,
                    totalPaise: r.expense.totalPaise,
                    listTitle: r.listTitle,
                  ))
              .toList(),
        );
  }

  @override
  Future<void> syncExpenseForList(int listId) =>
      _dao.syncExpenseForList(listId);

  @override
  Stream<List<MonthlySummary>> watchMonthlySummaries() {
    // Bucket expenses into local months in Dart (not SQL) so timezone handling
    // matches the rest of the app (PRD: store UTC, report by local month).
    return watchExpenses().map((expenses) {
      final byMonth = <YearMonth, List<Expense>>{};
      for (final e in expenses) {
        byMonth.putIfAbsent(YearMonth.fromDate(e.date), () => []).add(e);
      }
      final summaries = byMonth.entries
          .map((entry) => MonthlySummary(
                month: entry.key,
                totalPaise:
                    entry.value.fold(0, (s, e) => s + e.totalPaise),
                tripCount: entry.value.length,
              ))
          .toList()
        ..sort((a, b) => b.month.compareTo(a.month)); // most recent first
      return summaries;
    });
  }

  @override
  Stream<List<int>> watchDailyTotals(YearMonth month) {
    return watchExpenses().map((expenses) {
      // One slot per day of the month (index 0 = day 1), all starting at 0.
      final totals = List<int>.filled(month.daysInMonth, 0);
      for (final e in expenses) {
        final local = e.date.toLocal();
        if (local.year == month.year && local.month == month.month) {
          totals[local.day - 1] += e.totalPaise;
        }
      }
      return totals;
    });
  }
}
