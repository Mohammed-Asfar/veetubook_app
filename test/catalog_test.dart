// Tests the catalog data layer + seeder against an in-memory drift database,
// and the money auto-calc used by the product form.

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/db/app_database.dart' hide Product, Category;
import 'package:veetubook/core/utils/money.dart';
import 'package:veetubook/features/catalog/data/catalog_dao.dart';
import 'package:veetubook/features/catalog/data/catalog_repository_impl.dart';
import 'package:veetubook/features/catalog/data/catalog_seed.dart';
import 'package:veetubook/features/catalog/domain/entities/product.dart';

void main() {
  late AppDatabase db;
  late CatalogRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = CatalogRepositoryImpl(CatalogDao(db));
  });

  tearDown(() async => db.close());

  test('seeder populates the catalog only when empty', () async {
    expect(await repo.productCount(), 0);
    await CatalogSeeder(repo).seedIfEmpty();
    final count = await repo.productCount();
    expect(count, greaterThan(30));

    // Running again is a no-op.
    await CatalogSeeder(repo).seedIfEmpty();
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
}
