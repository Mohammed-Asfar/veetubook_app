import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart' as db;
import '../domain/entities/grocery_list.dart';
import '../domain/entities/list_item.dart';
import '../domain/lists_repository.dart';
import 'lists_dao.dart';

/// SQLite-backed implementation of [ListsRepository].
class ListsRepositoryImpl implements ListsRepository {
  ListsRepositoryImpl(this._dao);

  final ListsDao _dao;

  @override
  Stream<List<GroceryList>> watchLists() =>
      _dao.watchLists().map((rows) => rows.map(_toList).toList());

  @override
  Future<GroceryList?> getList(int id) async {
    final row = await _dao.getListById(id);
    return row == null ? null : _toList(row);
  }

  @override
  Future<GroceryList> createList(String title) async {
    final unique = await _uniqueTitle(title);
    final createdAt = DateTime.now().toUtc();
    final id = await _dao.insertList(
      db.GroceryListsCompanion.insert(title: unique, createdAt: createdAt),
    );
    return GroceryList(id: id, title: unique, createdAt: createdAt);
  }

  @override
  Future<void> renameList(int id, String title) async {
    final unique = await _uniqueTitle(title, exceptId: id);
    await _dao.updateListTitle(id, unique);
  }

  @override
  Future<bool> isNameAvailable(String title, {int? exceptId}) async {
    final needle = title.trim().toLowerCase();
    final rows = await _dao.watchLists().first;
    return !rows.any((l) =>
        l.id != exceptId && l.title.trim().toLowerCase() == needle);
  }

  @override
  Future<String> suggestListName(String baseName, String datePart) async {
    // Next sequence number = one more than the current list count.
    final rows = await _dao.watchLists().first;
    final seq = rows.length + 1;
    return _uniqueTitle('$baseName $seq - $datePart');
  }

  /// Returns [title] if free, otherwise appends " (2)", " (3)" … until unique.
  Future<String> _uniqueTitle(String title, {int? exceptId}) async {
    final base = title.trim();
    if (await isNameAvailable(base, exceptId: exceptId)) return base;
    for (var n = 2;; n++) {
      final candidate = '$base ($n)';
      if (await isNameAvailable(candidate, exceptId: exceptId)) return candidate;
    }
  }

  @override
  Future<void> setListDate(int id, DateTime date) =>
      _dao.updateListDate(id, date.toUtc());

  @override
  Future<void> deleteList(int id) => _dao.deleteListById(id);

  @override
  Stream<List<ListItem>> watchItems(int listId) =>
      _dao.watchItems(listId).map((rows) => rows.map(_toItem).toList());

  @override
  Future<int> addItem(ListItem item) =>
      _dao.insertItem(_itemCompanion(item, forInsert: true));

  @override
  Future<void> updateItem(ListItem item) =>
      _dao.updateItem(_itemCompanion(item, forInsert: false));

  @override
  Future<void> removeItem(int itemId) => _dao.deleteItem(itemId);

  @override
  Future<void> setBought(int itemId, bool isBought) =>
      _dao.setBought(itemId, isBought);

  // ---- mappers ----

  GroceryList _toList(db.GroceryList row) => GroceryList(
        id: row.id,
        title: row.title,
        createdAt: row.createdAt,
        status: row.status == 'completed'
            ? ListStatus.completed
            : ListStatus.active,
      );

  ListItem _toItem(db.ListItem row) => ListItem(
        id: row.id,
        listId: row.listId,
        productId: row.productId,
        nameTa: row.nameTa,
        nameEn: row.nameEn,
        unit: row.unit,
        qty: Decimal.tryParse(row.qty) ?? Decimal.one,
        unitPricePaise: row.unitPricePaise,
        linePricePaise: row.linePricePaise,
        isPriceOverridden: row.isPriceOverridden,
        isBought: row.isBought,
      );

  db.ListItemsCompanion _itemCompanion(ListItem item, {required bool forInsert}) {
    // Always persist the computed line price so DB totals stay consistent.
    final line = item.computedLinePaise();
    return db.ListItemsCompanion(
      id: item.id == null ? const Value.absent() : Value(item.id!),
      listId: Value(item.listId),
      productId: Value(item.productId),
      nameTa: Value(item.nameTa),
      nameEn: Value(item.nameEn),
      unit: Value(item.unit),
      qty: Value(item.qty.toString()),
      unitPricePaise: Value(item.unitPricePaise),
      linePricePaise: Value(line),
      isPriceOverridden: Value(item.isPriceOverridden),
      isBought: Value(item.isBought),
    );
  }
}
