// Tests the catalog data layer + seeder against an in-memory drift database,
// and the money auto-calc used by the product form.

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/db/app_database.dart'
    hide Product, Category, ListItem;
import 'package:veetubook/core/utils/money.dart';
import 'package:veetubook/features/catalog/data/catalog_dao.dart';
import 'package:veetubook/features/catalog/data/catalog_repository_impl.dart';
import 'package:veetubook/features/catalog/data/catalog_seed.dart';
import 'package:veetubook/features/catalog/domain/entities/product.dart';
import 'package:veetubook/features/lists/data/lists_dao.dart';
import 'package:veetubook/features/lists/data/lists_repository_impl.dart';
import 'package:veetubook/features/lists/domain/entities/list_item.dart';

void main() {
  late AppDatabase db;
  late CatalogRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = CatalogRepositoryImpl(CatalogDao(db));
  });

  tearDown(() async => db.close());

  test('seeder populates a rich catalog with categories only when empty',
      () async {
    expect(await repo.productCount(), 0);
    await CatalogSeeder(repo, CatalogDao(db)).seedIfEmpty();
    final count = await repo.productCount();
    expect(count, greaterThan(200)); // large Indian catalog

    // Categories are seeded too (Vegetables, Non-Veg, Ready-to-Cook, ...).
    final categories = await repo.watchCategories().first;
    final names = categories.map((c) => c.nameEn).toList();
    expect(
      names,
      containsAll([
        'Vegetables',
        'Non-Veg',
        'Fruits',
        'Snacks',
        'Ready-to-Cook',
        'Household',
      ]),
    );

    // Running again is a no-op.
    await CatalogSeeder(repo, CatalogDao(db)).seedIfEmpty();
    expect(await repo.productCount(), count);
  });

  test('saveProduct rejects a product with no name', () async {
    expect(
      () => repo.saveProduct(Product(baseQty: Decimal.one)),
      throwsArgumentError,
    );
  });

  test('soft-deleted products drop out of the watch stream', () async {
    final id = await repo.saveProduct(
      Product(nameEn: 'Rice', baseQty: Decimal.one, basePricePaise: 5000),
    );
    expect((await repo.watchProducts().first).length, 1);

    await repo.deleteProduct(id);
    expect((await repo.watchProducts().first), isEmpty);

    // But the row still exists (history preserved).
    expect(await repo.getProduct(id), isNotNull);
  });

  test('auto-calc: ₹50/kg for 3 kg = ₹150; 250 g = ₹12.50', () {
    // 5000 paise per 1 kg
    final threeKg = Money.lineTotalPaise(
      basePricePaise: 5000,
      baseQty: Decimal.one,
      qty: Decimal.fromInt(3),
    );
    expect(threeKg, 15000); // ₹150.00

    final quarterKg = Money.lineTotalPaise(
      basePricePaise: 5000,
      baseQty: Decimal.one,
      qty: Decimal.parse('0.25'),
    );
    expect(quarterKg, 1250); // ₹12.50
  });

  test('findByName matches case-insensitively (prevents milk/Milk dupes)',
      () async {
    await repo.saveProduct(
      Product(nameEn: 'milk', baseQty: Decimal.one, basePricePaise: 4800),
    );

    // Same word in different case / with surrounding spaces resolves to the
    // existing product rather than a new one.
    expect((await repo.findByName('milk'))?.nameEn, 'milk');
    expect((await repo.findByName('Milk'))?.nameEn, 'milk');
    expect((await repo.findByName('  MILK '))?.nameEn, 'milk');

    // A genuinely different name has no match.
    expect(await repo.findByName('bread'), isNull);
  });

  test('watchRecentProducts returns products added to lists, most recent first',
      () async {
    final lists = ListsRepositoryImpl(ListsDao(db));
    final rice = await repo.saveProduct(
      Product(nameEn: 'Rice', baseQty: Decimal.one, basePricePaise: 5000),
    );
    final milk = await repo.saveProduct(
      Product(nameEn: 'Milk', baseQty: Decimal.one, basePricePaise: 4800),
    );
    // Oil exists but is never added to a list -> shouldn't appear in Recent.
    await repo.saveProduct(
      Product(nameEn: 'Oil', baseQty: Decimal.one, basePricePaise: 12000),
    );

    final listId = (await lists.createList('Trip')).id!;
    // Add rice first, then milk (milk is more recent).
    await lists.addItem(
      ListItem(listId: listId, productId: rice, qty: Decimal.one),
    );
    await lists.addItem(
      ListItem(listId: listId, productId: milk, qty: Decimal.one),
    );

    final recent = await repo.watchRecentProducts().first;
    expect(recent.map((p) => p.nameEn).toList(), ['Milk', 'Rice']);
  });
}
