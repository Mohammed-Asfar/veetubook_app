import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/tables.dart';

part 'lists_dao.g.dart';

/// Drift data-access object for grocery lists and their items.
@DriftAccessor(tables: [GroceryLists, ListItems])
class ListsDao extends DatabaseAccessor<AppDatabase> with _$ListsDaoMixin {
  ListsDao(super.db);

  Stream<List<GroceryList>> watchLists() {
    return (select(groceryLists)
          ..orderBy([(l) => OrderingTerm.desc(l.createdAt)]))
        .watch();
  }

  Future<GroceryList?> getListById(int id) =>
      (select(groceryLists)..where((l) => l.id.equals(id))).getSingleOrNull();

  Future<int> insertList(GroceryListsCompanion companion) =>
      into(groceryLists).insert(companion);

  Future<void> updateListTitle(int id, String title) {
    return (update(groceryLists)..where((l) => l.id.equals(id)))
        .write(GroceryListsCompanion(title: Value(title)));
  }

  Future<void> updateListDate(int id, DateTime date) {
    return (update(groceryLists)..where((l) => l.id.equals(id)))
        .write(GroceryListsCompanion(createdAt: Value(date)));
  }

  Future<void> deleteListById(int id) =>
      (delete(groceryLists)..where((l) => l.id.equals(id))).go();

  Stream<List<ListItem>> watchItems(int listId) {
    return (select(listItems)..where((i) => i.listId.equals(listId))).watch();
  }

  Future<int> insertItem(ListItemsCompanion companion) =>
      into(listItems).insert(companion);

  Future<void> updateItem(ListItemsCompanion companion) =>
      update(listItems).replace(companion);

  Future<void> deleteItem(int id) =>
      (delete(listItems)..where((i) => i.id.equals(id))).go();

  Future<void> setBought(int id, bool isBought) {
    return (update(listItems)..where((i) => i.id.equals(id)))
        .write(ListItemsCompanion(isBought: Value(isBought)));
  }
}
