import 'entities/grocery_list.dart';
import 'entities/list_item.dart';

/// Repository interface for grocery lists and their items. Lives in `domain`
/// as the seam for a future cloud-backed implementation.
abstract interface class ListsRepository {
  Stream<List<GroceryList>> watchLists();

  Future<GroceryList?> getList(int id);
  Future<int> createList(String title);
  Future<void> renameList(int id, String title);
  Future<void> deleteList(int id);

  /// Reactive stream of a single list's items.
  Stream<List<ListItem>> watchItems(int listId);

  Future<int> addItem(ListItem item);
  Future<void> updateItem(ListItem item);
  Future<void> removeItem(int itemId);

  /// Toggle bought state for an item.
  Future<void> setBought(int itemId, bool isBought);
}
