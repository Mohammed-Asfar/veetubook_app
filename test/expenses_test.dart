// Tests the expenses data layer: finishTrip's transactional snapshot of bought
// items, idempotency, list-completed side effect, and monthly bucketing.

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/db/app_database.dart' hide ListItem, Expense;
import 'package:veetubook/features/expenses/data/expenses_dao.dart';
import 'package:veetubook/features/expenses/data/expenses_repository_impl.dart';
import 'package:veetubook/features/lists/data/lists_dao.dart';
import 'package:veetubook/features/lists/data/lists_repository_impl.dart';
import 'package:veetubook/features/lists/domain/entities/list_item.dart';

void main() {
  late AppDatabase db;
  late ListsRepositoryImpl lists;
  late ExpensesRepositoryImpl expenses;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    lists = ListsRepositoryImpl(ListsDao(db));
    expenses = ExpensesRepositoryImpl(ExpensesDao(db));
  });

  tearDown(() async => db.close());

  Future<int> seedTrip() async {
    final listId = await lists.createList('Trip');
    // Two items: one bought (₹100), one not (₹50).
    final a = await lists.addItem(ListItem(
      listId: listId,
      nameEn: 'Bought',
      qty: Decimal.one,
      unitPricePaise: 10000,
    ));
    await lists.addItem(ListItem(
      listId: listId,
      nameEn: 'NotBought',
      qty: Decimal.one,
      unitPricePaise: 5000,
    ));
    await lists.setBought(a, true);
    return listId;
  }

  test('finishTrip snapshots only bought items and marks list completed',
      () async {
    final listId = await seedTrip();
    final expenseId = await expenses.finishTrip(listId);
    expect(expenseId, isPositive);

    final rows = await expenses.watchExpenses().first;
    expect(rows.single.totalPaise, 10000); // only the bought ₹100
    expect(rows.single.listTitle, 'Trip');

    // The list is now completed.
    final list = await lists.getList(listId);
    expect(list!.status.name, 'completed');
  });

  test('finishTrip is idempotent per list (updates, not duplicates)', () async {
    final listId = await seedTrip();
    final first = await expenses.finishTrip(listId);
    final second = await expenses.finishTrip(listId);
    expect(first, second); // same expense id

    final rows = await expenses.watchExpenses().first;
    expect(rows.length, 1); // not duplicated
  });

  test('monthly summaries aggregate totals and trip counts', () async {
    final l1 = await seedTrip();
    await expenses.finishTrip(l1);
    final l2 = await seedTrip();
    await expenses.finishTrip(l2);

    final months = await expenses.watchMonthlySummaries().first;
    // Both trips are in the current month.
    expect(months.length, 1);
    expect(months.single.tripCount, 2);
    expect(months.single.totalPaise, 20000); // ₹100 + ₹100
  });
}
