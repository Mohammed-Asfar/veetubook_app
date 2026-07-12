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
  Future<int> createList(String title) {
    return _dao.insertList(
      db.GroceryListsCompanion.insert(
        title: title,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Future<void> renameList(int id, String title) =>
      _dao.updateListTitle(id, title);

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
