// Tests ListDetailCubit.editItem: editing an item's price from the list updates
// the item's line total, writes the new price back to the catalog product, and
// keeps the expense in sync.

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/db/app_database.dart' hide Product;
import 'package:veetubook/features/catalog/data/catalog_dao.dart';
import 'package:veetubook/features/catalog/data/catalog_repository_impl.dart';
import 'package:veetubook/features/catalog/domain/entities/product.dart';
import 'package:veetubook/features/expenses/data/expenses_dao.dart';
import 'package:veetubook/features/expenses/data/expenses_repository_impl.dart';
import 'package:veetubook/features/lists/data/lists_dao.dart';
import 'package:veetubook/features/lists/data/lists_repository_impl.dart';
import 'package:veetubook/features/lists/presentation/cubit/list_detail_cubit.dart';

void main() {
  late AppDatabase db;
  late CatalogRepositoryImpl catalog;
  late ListsRepositoryImpl lists;
  late ExpensesRepositoryImpl expenses;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    catalog = CatalogRepositoryImpl(CatalogDao(db));
    lists = ListsRepositoryImpl(ListsDao(db));
    expenses = ExpensesRepositoryImpl(ExpensesDao(db));
  });

  tearDown(() async => db.close());

  test('editItem updates the item AND the catalog product price', () async {
    // Rice saved at ₹50/kg.
    final productId = await catalog.saveProduct(
      Product(nameEn: 'Rice', unit: 'kg', baseQty: Decimal.one, basePricePaise: 5000),
    );
    final list = await lists.createList('Trip');
    final cubit = ListDetailCubit(lists, expenses, catalog, list.id!);
    addTearDown(cubit.close);

    // Add rice at the saved price, mark bought.
    final product = (await catalog.getProduct(productId))!;
    await cubit.addFromProduct(product, Decimal.fromInt(2)); // 2 kg -> ₹100
    var item = (await lists.watchItems(list.id!).first).single;
    await cubit.setBought(item, true);

    // In the shop, rice is actually ₹60/kg. Edit right on the list item,
    // changing price and renaming; category is applied to the product.
    item = (await lists.watchItems(list.id!).first).single;
    await cubit.editItem(
      item,
      nameEn: 'Basmati Rice',
      nameTa: null,
      unit: 'kg',
      unitPricePaise: 6000,
      qty: Decimal.fromInt(2),
    );

    // The item's line total is now 2 kg × ₹60 = ₹120, and it's renamed.
    item = (await lists.watchItems(list.id!).first).single;
    expect(item.unitPricePaise, 6000);
    expect(item.linePricePaise, 12000);
    expect(item.nameEn, 'Basmati Rice');

    // The catalog product's saved price and name were updated for next time.
    final updated = (await catalog.getProduct(productId))!;
    expect(updated.basePricePaise, 6000);
    expect(updated.nameEn, 'Basmati Rice');

    // The expense reflects the edited price.
    final exp = await expenses.watchExpenses().first;
    expect(exp.single.totalPaise, 12000);
  });
}
