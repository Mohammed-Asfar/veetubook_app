// Tests the lists data layer: list CRUD, item snapshotting, and the bought vs
// planned totals used by the shopping screen.

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/db/app_database.dart'
    hide GroceryList, ListItem, Product;
import 'package:veetubook/features/catalog/domain/entities/product.dart';
import 'package:veetubook/features/lists/data/lists_dao.dart';
import 'package:veetubook/features/lists/data/lists_repository_impl.dart';
import 'package:veetubook/features/lists/domain/entities/list_item.dart';

void main() {
  late AppDatabase db;
  late ListsRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = ListsRepositoryImpl(ListsDao(db));
  });

  tearDown(() async => db.close());

  test('create, rename and delete a list', () async {
    final id = await repo.createList('July groceries');
    expect((await repo.watchLists().first).single.title, 'July groceries');

    await repo.renameList(id, 'Weekly');
    expect((await repo.getList(id))!.title, 'Weekly');

    await repo.deleteList(id);
    expect(await repo.watchLists().first, isEmpty);
  });

  test('adding a catalog product snapshots price and auto-calcs the line',
      () async {
    final listId = await repo.createList('Trip');
    // Rice ₹50/kg (5000 paise), quantity 3 -> ₹150 (15000 paise).
    // productId is left null here (no catalog row persisted) — this test
    // isolates the price-snapshot/auto-calc behaviour, not the FK.
    final product = Product(
      nameEn: 'Rice',
      unit: 'kg',
      baseQty: Decimal.one,
      basePricePaise: 5000,
    );
    await repo.addItem(
      ListItem(
        listId: listId,
        nameEn: product.nameEn,
        unit: product.unit,
        qty: Decimal.fromInt(3),
        unitPricePaise: product.unitPricePaise,
      ),
    );

    final items = await repo.watchItems(listId).first;
    expect(items.single.linePricePaise, 15000);
    expect(items.single.unitPricePaise, 5000);
  });

  test('bought total counts only checked items; planned counts all', () async {
    final listId = await repo.createList('Trip');
    final a = await repo.addItem(ListItem(
      listId: listId,
      nameEn: 'A',
      qty: Decimal.one,
      unitPricePaise: 1000,
    ));
    await repo.addItem(ListItem(
      listId: listId,
      nameEn: 'B',
      qty: Decimal.one,
      unitPricePaise: 2000,
    ));

    var items = await repo.watchItems(listId).first;
    final planned = items.fold<int>(0, (s, i) => s + i.linePricePaise);
    expect(planned, 3000);

    // Mark A as bought.
    await repo.setBought(a, true);
    items = await repo.watchItems(listId).first;
    final bought = items
        .where((i) => i.isBought)
        .fold<int>(0, (s, i) => s + i.linePricePaise);
    expect(bought, 1000);
  });

  test('changing qty re-runs auto-calc unless price overridden', () async {
    final listId = await repo.createList('Trip');
    final id = await repo.addItem(ListItem(
      listId: listId,
      nameEn: 'Oil',
      qty: Decimal.one,
      unitPricePaise: 10000, // ₹100 / unit
    ));

    var item = (await repo.watchItems(listId).first).single;
    await repo.updateItem(item.copyWith(qty: Decimal.fromInt(2)));
    item = (await repo.watchItems(listId).first).single;
    expect(item.linePricePaise, 20000); // ₹200

    // Override to a manual price, then changing qty must NOT recompute.
    await repo.updateItem(
      item.copyWith(linePricePaise: 15000, isPriceOverridden: true),
    );
    item = (await repo.watchItems(listId).first).single;
    await repo.updateItem(item.copyWith(qty: Decimal.fromInt(5)));
    item = (await repo.watchItems(listId).first).single;
    expect(item.linePricePaise, 15000); // stays overridden

    expect(id, isPositive);
  });
}
