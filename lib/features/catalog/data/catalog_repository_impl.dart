import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart' as db;
import '../domain/catalog_repository.dart';
import '../domain/entities/category.dart';
import '../domain/entities/product.dart';
import 'catalog_dao.dart';

/// SQLite-backed implementation of [CatalogRepository] using [CatalogDao].
/// Maps between drift row classes and domain entities in one place.
class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._dao);

  final CatalogDao _dao;

  @override
  Stream<List<Product>> watchProducts() =>
      _dao.watchProducts().map((rows) => rows.map(_toProduct).toList());

  @override
  Stream<List<Category>> watchCategories() =>
      _dao.watchCategories().map((rows) => rows.map(_toCategory).toList());

  @override
  Future<Product?> getProduct(int id) async {
    final row = await _dao.getProductById(id);
    return row == null ? null : _toProduct(row);
  }

  @override
  Future<int> saveProduct(Product product) {
    if (product.hasNoName) {
      throw ArgumentError('A product needs at least a Tamil or English name.');
    }
    final companion = db.ProductsCompanion(
      id: product.id == null ? const Value.absent() : Value(product.id!),
      nameTa: Value(product.nameTa),
      nameEn: Value(product.nameEn),
      categoryId: Value(product.categoryId),
      unit: Value(product.unit),
      baseQty: Value(product.baseQty.toString()),
      basePricePaise: Value(product.basePricePaise),
      isDeleted: Value(product.isDeleted),
      updatedAt: Value(DateTime.now().toUtc()),
    );
    return _dao.upsertProduct(companion);
  }

  @override
  Future<void> deleteProduct(int id) => _dao.softDeleteProduct(id);

  @override
  Future<int> saveCategory(Category category) {
    final companion = db.CategoriesCompanion(
      id: category.id == null ? const Value.absent() : Value(category.id!),
      nameTa: Value(category.nameTa),
      nameEn: Value(category.nameEn),
    );
    return _dao.upsertCategory(companion);
  }

  @override
  Future<int> productCount() => _dao.countProducts();

  // ---- mappers ----

  Product _toProduct(db.Product row) => Product(
        id: row.id,
        nameTa: row.nameTa,
        nameEn: row.nameEn,
        categoryId: row.categoryId,
        unit: row.unit,
        baseQty: Decimal.tryParse(row.baseQty) ?? Decimal.one,
        basePricePaise: row.basePricePaise,
        isDeleted: row.isDeleted,
      );

  Category _toCategory(db.Category row) => Category(
        id: row.id,
        nameTa: row.nameTa,
        nameEn: row.nameEn,
      );
}
