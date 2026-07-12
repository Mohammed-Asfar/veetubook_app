import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/tables.dart';

part 'expenses_dao.g.dart';

/// Row shape for an expense joined with its list title.
class ExpenseWithTitle {
  ExpenseWithTitle(this.expense, this.listTitle);
  final Expense expense;
  final String listTitle;
}

@DriftAccessor(tables: [Expenses, GroceryLists, ListItems])
class ExpensesDao extends DatabaseAccessor<AppDatabase>
    with _$ExpensesDaoMixin {
  ExpensesDao(super.db);

  /// All expenses joined with their list title, most recent first.
  Stream<List<ExpenseWithTitle>> watchExpensesWithTitle() {
    final query = select(expenses).join([
      innerJoin(groceryLists, groceryLists.id.equalsExp(expenses.listId)),
    ])
      ..orderBy([OrderingTerm.desc(expenses.date)]);
    return query.watch().map(
          (rows) => rows
              .map((r) => ExpenseWithTitle(
                    r.readTable(expenses),
                    r.readTable(groceryLists).title,
                  ))
              .toList(),
        );
  }

  /// Sum of bought items' line prices for a list.
  Future<int> boughtTotalForList(int listId) async {
    final sum = listItems.linePricePaise.sum();
    final query = selectOnly(listItems)
      ..where(listItems.listId.equals(listId) & listItems.isBought.equals(true))
      ..addColumns([sum]);
    final row = await query.getSingleOrNull();
    return row?.read(sum) ?? 0;
  }

  Future<Expense?> expenseForList(int listId) =>
      (select(expenses)..where((e) => e.listId.equals(listId)))
          .getSingleOrNull();

  /// Keep the list's expense record in sync with its bought-items total.
  ///
  /// Called automatically whenever items change (bought/qty/price). Runs in a
  /// transaction so the read-then-write is atomic:
  /// - bought total > 0  -> upsert an expense with that total (idempotent).
  /// - bought total == 0 -> delete the expense so ₹0 entries don't linger.
  Future<void> syncExpenseForList(int listId) {
    return transaction(() async {
      final total = await boughtTotalForList(listId);
      final now = DateTime.now().toUtc();
      final existing = await expenseForList(listId);

      if (total <= 0) {
        if (existing != null) {
          await (delete(expenses)..where((e) => e.id.equals(existing.id))).go();
        }
        return;
      }

      // The expense is dated by the LIST's date, not "now", so backdating a
      // list (a forgotten past trip) moves its spend into the right month.
      final list = await (select(groceryLists)
            ..where((l) => l.id.equals(listId)))
          .getSingleOrNull();
      final expenseDate = list?.createdAt ?? now;

      if (existing != null) {
        await (update(expenses)..where((e) => e.id.equals(existing.id))).write(
          ExpensesCompanion(
            date: Value(expenseDate),
            totalPaise: Value(total),
            updatedAt: Value(now),
          ),
        );
      } else {
        await into(expenses).insert(
          ExpensesCompanion.insert(
            listId: listId,
            date: expenseDate,
            totalPaise: Value(total),
            updatedAt: Value(now),
          ),
        );
      }
    });
  }
}
