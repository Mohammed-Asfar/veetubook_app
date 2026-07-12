// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lists_dao.dart';

// ignore_for_file: type=lint
mixin _$ListsDaoMixin on DatabaseAccessor<AppDatabase> {
  $GroceryListsTable get groceryLists => attachedDatabase.groceryLists;
  $CategoriesTable get categories => attachedDatabase.categories;
  $ProductsTable get products => attachedDatabase.products;
  $ListItemsTable get listItems => attachedDatabase.listItems;
  ListsDaoManager get managers => ListsDaoManager(this);
}

class ListsDaoManager {
  final _$ListsDaoMixin _db;
  ListsDaoManager(this._db);
  $$GroceryListsTableTableManager get groceryLists =>
      $$GroceryListsTableTableManager(_db.attachedDatabase, _db.groceryLists);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db.attachedDatabase, _db.products);
  $$ListItemsTableTableManager get listItems =>
      $$ListItemsTableTableManager(_db.attachedDatabase, _db.listItems);
}
