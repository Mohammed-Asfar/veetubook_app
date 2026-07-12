// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_dao.dart';

// ignore_for_file: type=lint
mixin _$ExpensesDaoMixin on DatabaseAccessor<AppDatabase> {
  $GroceryListsTable get groceryLists => attachedDatabase.groceryLists;
  $ExpensesTable get expenses => attachedDatabase.expenses;
  $CategoriesTable get categories => attachedDatabase.categories;
  $ProductsTable get products => attachedDatabase.products;
  $ListItemsTable get listItems => attachedDatabase.listItems;
  ExpensesDaoManager get managers => ExpensesDaoManager(this);
}

class ExpensesDaoManager {
  final _$ExpensesDaoMixin _db;
  ExpensesDaoManager(this._db);
  $$GroceryListsTableTableManager get groceryLists =>
      $$GroceryListsTableTableManager(_db.attachedDatabase, _db.groceryLists);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db.attachedDatabase, _db.expenses);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db.attachedDatabase, _db.products);
  $$ListItemsTableTableManager get listItems =>
      $$ListItemsTableTableManager(_db.attachedDatabase, _db.listItems);
}
