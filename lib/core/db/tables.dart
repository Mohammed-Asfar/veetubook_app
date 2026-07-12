import 'package:drift/drift.dart';

/// Drift table definitions for veetubook.
///
/// Conventions (see PRD):
/// - Money is stored as **integer paise** (never floating point).
/// - Timestamps stored in **UTC**.
/// - Product/category names are bilingual (ta + en); at least one required
///   (enforced in the domain layer).

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameTa => text().nullable()();
  TextColumn get nameEn => text().nullable()();
}

/// Reusable product "price template": base price per base quantity.
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameTa => text().nullable()();
  TextColumn get nameEn => text().nullable()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  TextColumn get unit => text().withDefault(const Constant('unit'))();

  /// Base quantity the [basePricePaise] applies to (e.g. 1 for ₹50/kg).
  /// Stored as text to preserve exact decimals (Decimal.parse).
  TextColumn get baseQty => text().withDefault(const Constant('1'))();

  /// Price (paise) for [baseQty] of this product.
  IntColumn get basePricePaise => integer().withDefault(const Constant(0))();

  /// Soft-delete so past expense snapshots stay intact when a product is
  /// removed (PRD edge case).
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class GroceryLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// 'active' | 'completed'
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// An item on a list. Price and name are SNAPSHOTTED here so editing/deleting
/// the source product never rewrites past lists/expenses (PRD).
class ListItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId =>
      integer().references(GroceryLists, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId =>
      integer().nullable().references(Products, #id, onDelete: KeyAction.setNull)();

  TextColumn get nameTa => text().nullable()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get unit => text().withDefault(const Constant('unit'))();

  /// Chosen quantity (exact decimal as text).
  TextColumn get qty => text().withDefault(const Constant('1'))();

  /// Snapshot of unit price in paise (basePrice / baseQty at add time).
  IntColumn get unitPricePaise => integer().withDefault(const Constant(0))();

  /// Auto = unitPrice * qty, but user-overridable.
  IntColumn get linePricePaise => integer().withDefault(const Constant(0))();
  BoolColumn get isPriceOverridden =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isBought => boolean().withDefault(const Constant(false))();
}

/// A completed shopping trip's expense record.
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId =>
      integer().references(GroceryLists, #id, onDelete: KeyAction.cascade)();

  /// Trip date, stored UTC; reports bucket by local month.
  DateTimeColumn get date => dateTime()();

  /// Total (paise) of bought items on the trip.
  IntColumn get totalPaise => integer().withDefault(const Constant(0))();

  // Sync-ready columns reserved for future cloud sync.
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}
