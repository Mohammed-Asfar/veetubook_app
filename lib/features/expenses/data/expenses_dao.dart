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

  /// Atomically mark the list completed and upsert its expense record.
  /// Returns the expense id.
  Future<int> finishTrip(int listId) {
    return transaction(() async {
      final total = await boughtTotalForList(listId);
      final now = DateTime.now().toUtc();

      // Mark the list completed.
      await (update(groceryLists)..where((l) => l.id.equals(listId))).write(
        GroceryListsCompanion(
          status: const Value('completed'),
          updatedAt: Value(now),
        ),
      );

      // Upsert the expense (idempotent per list).
      final existing = await expenseForList(listId);
      if (existing != null) {
        await (update(expenses)..where((e) => e.id.equals(existing.id))).write(
          ExpensesCompanion(
            date: Value(now),
            totalPaise: Value(total),
            updatedAt: Value(now),
          ),
        );
        return existing.id;
      }
      return into(expenses).insert(
        ExpensesCompanion.insert(
          listId: listId,
          date: now,
          totalPaise: Value(total),
          updatedAt: Value(now),
        ),
      );
    });
  }
}
