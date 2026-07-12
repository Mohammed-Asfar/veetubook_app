import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/tables.dart';

part 'catalog_dao.g.dart';

/// Drift data-access object for catalog tables. Returns generated row classes
/// (`db.Product` / `db.Category`); the repository maps these to domain entities.
@DriftAccessor(tables: [Products, Categories, ListItems])
class CatalogDao extends DatabaseAccessor<AppDatabase> with _$CatalogDaoMixin {
  CatalogDao(super.db);

  /// Non-deleted products, alphabetical-ish by id insertion order.
  Stream<List<Product>> watchProducts() {
    return (select(products)..where((p) => p.isDeleted.equals(false)))
        .watch();
  }

  /// Non-deleted products that have been added to any list, most-recently-added
  /// first. Recency is derived from MAX(list_items.id) per product (higher id =
  /// added later). [limit] caps the result.
  Stream<List<Product>> watchRecentProducts({int limit = 20}) {
    final lastAdded = listItems.id.max();
    final query = select(products).join([
      innerJoin(listItems, listItems.productId.equalsExp(products.id)),
    ])
      ..where(products.isDeleted.equals(false))
      ..groupBy([products.id])
      ..orderBy([OrderingTerm.desc(lastAdded)])
      ..limit(limit);
    return query.watch().map(
          (rows) => rows.map((r) => r.readTable(products)).toList(),
        );
  }

  Stream<List<Category>> watchCategories() => select(categories).watch();

  Future<Product?> getProductById(int id) =>
      (select(products)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> upsertProduct(ProductsCompanion companion) =>
      into(products).insertOnConflictUpdate(companion);

  /// Soft-delete keeps history intact.
  Future<void> softDeleteProduct(int id) {
    return (update(products)..where((p) => p.id.equals(id))).write(
      const ProductsCompanion(isDeleted: Value(true)),
    );
  }

  Future<int> upsertCategory(CategoriesCompanion companion) =>
      into(categories).insertOnConflictUpdate(companion);

  Future<int> countProducts() async {
    final countExp = products.id.count();
    final query = selectOnly(products)
      ..where(products.isDeleted.equals(false))
      ..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }
}
