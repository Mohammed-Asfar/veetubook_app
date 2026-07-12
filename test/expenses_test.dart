// Tests the expenses data layer: automatic expense sync from the bought-items
// total (upsert when > 0, delete when 0), idempotency, and monthly bucketing.

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

  /// Creates a list with one bought item (₹100) and one unbought (₹50),
  /// returning (listId, boughtItemId).
  Future<(int, int)> seedList() async {
    final listId = (await lists.createList('Trip')).id!;
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
    return (listId, a);
  }

  test('syncing records an expense from only the bought-items total', () async {
    final (listId, boughtId) = await seedList();

    // Nothing bought yet -> no expense.
    await expenses.syncExpenseForList(listId);
    expect(await expenses.watchExpenses().first, isEmpty);

    // Mark the ₹100 item bought -> an expense of ₹100 appears.
    await lists.setBought(boughtId, true);
    await expenses.syncExpenseForList(listId);

    final rows = await expenses.watchExpenses().first;
    expect(rows.single.totalPaise, 10000); // only the bought ₹100
    expect(rows.single.listTitle, 'Trip');
  });

  test('syncing is idempotent (updates, never duplicates)', () async {
    final (listId, boughtId) = await seedList();
    await lists.setBought(boughtId, true);

    await expenses.syncExpenseForList(listId);
    await expenses.syncExpenseForList(listId);

    final rows = await expenses.watchExpenses().first;
    expect(rows.length, 1); // not duplicated
  });

  test('unmarking the last bought item removes the expense', () async {
    final (listId, boughtId) = await seedList();

    await lists.setBought(boughtId, true);
    await expenses.syncExpenseForList(listId);
    expect(await expenses.watchExpenses().first, isNotEmpty);

    // Unbuy everything -> the ₹0 expense is deleted, not left lingering.
    await lists.setBought(boughtId, false);
    await expenses.syncExpenseForList(listId);
    expect(await expenses.watchExpenses().first, isEmpty);
  });

  test('monthly summaries aggregate totals and counts', () async {
    final (l1, b1) = await seedList();
    await lists.setBought(b1, true);
    await expenses.syncExpenseForList(l1);

    final (l2, b2) = await seedList();
    await lists.setBought(b2, true);
    await expenses.syncExpenseForList(l2);

    final months = await expenses.watchMonthlySummaries().first;
    expect(months.length, 1); // both in the current month
    expect(months.single.tripCount, 2);
    expect(months.single.totalPaise, 20000); // ₹100 + ₹100
  });
}
