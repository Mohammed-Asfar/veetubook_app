import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/tables.dart';

part 'catalog_dao.g.dart';

/// A plain row for [CatalogDao.seedCatalog]: one starter product plus the
/// English name of the category it belongs to.
class SeedProductRow {
  const SeedProductRow({
    required this.nameEn,
    required this.nameTa,
    required this.unit,
    required this.basePricePaise,
    required this.categoryEn,
  });

  final String nameEn;
  final String nameTa;
  final String unit;
  final int basePricePaise;
  final String categoryEn;
}

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

  /// One-shot fetch of all non-deleted products (no stream subscription).
  Future<List<Product>> getAllProducts() =>
      (select(products)..where((p) => p.isDeleted.equals(false))).get();

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

  /// Bulk-seeds the starter catalog in a SINGLE transaction: categories first
  /// (to obtain their ids), then all products in one batched insert. This turns
  /// the ~240 individual awaited writes the seeder used to do into effectively
  /// one DB round-trip, so first-launch doesn't stall the Products page.
  ///
  /// [categoryRows] are (nameEn, nameTa); [productRows] reference a category by
  /// its English name via [SeedProductRow.categoryEn].
  Future<void> seedCatalog(
    List<(String, String)> categoryRows,
    List<SeedProductRow> productRows,
  ) {
    return transaction(() async {
      final idByEn = <String, int>{};
      for (final c in categoryRows) {
        final id = await into(categories).insert(
          CategoriesCompanion.insert(
            nameEn: Value(c.$1),
            nameTa: Value(c.$2),
          ),
        );
        idByEn[c.$1] = id;
      }

      await batch((b) {
        b.insertAll(
          products,
          [
            for (final p in productRows)
              ProductsCompanion.insert(
                nameEn: Value(p.nameEn),
                nameTa: Value(p.nameTa),
                categoryId: Value(idByEn[p.categoryEn]),
                unit: Value(p.unit),
                baseQty: const Value('1'),
                basePricePaise: Value(p.basePricePaise),
                updatedAt: Value(DateTime.now().toUtc()),
              ),
          ],
        );
      });
    });
  }

  Future<int> countProducts() async {
    final countExp = products.id.count();
    final query = selectOnly(products)
      ..where(products.isDeleted.equals(false))
      ..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }
}
