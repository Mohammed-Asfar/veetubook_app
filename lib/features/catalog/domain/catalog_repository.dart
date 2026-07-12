import 'entities/category.dart';
import 'entities/product.dart';

/// Repository interface for the catalog feature.
///
/// This lives in `domain` and is the seam that lets the data source change
/// (SQLite now, Firebase/cloud later) without touching presentation/BLoC.
abstract interface class CatalogRepository {
  /// Reactive stream of non-deleted products, so the UI auto-updates on change.
  Stream<List<Product>> watchProducts();

  /// Non-deleted products recently added to any list, most-recent first.
  Stream<List<Product>> watchRecentProducts({int limit});

  /// Reactive stream of categories.
  Stream<List<Category>> watchCategories();

  Future<Product?> getProduct(int id);

  /// Find a non-deleted product whose Tamil or English name matches [name]
  /// case-insensitively (trimmed). Used to avoid creating duplicate products
  /// like "milk" and "Milk". Returns null if none.
  Future<Product?> findByName(String name);

  /// Insert or update. Returns the row id. Throws [ArgumentError] if the
  /// product has no name (PRD: at least one name required).
  Future<int> saveProduct(Product product);

  /// Soft-delete so past expense snapshots stay intact (PRD edge case).
  Future<void> deleteProduct(int id);

  Future<int> saveCategory(Category category);

  /// Number of non-deleted products (used to decide whether to seed).
  Future<int> productCount();
}
