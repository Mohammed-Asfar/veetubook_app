import 'entities/grocery_list.dart';
import 'entities/list_item.dart';

/// Repository interface for grocery lists and their items. Lives in `domain`
/// as the seam for a future cloud-backed implementation.
abstract interface class ListsRepository {
  Stream<List<GroceryList>> watchLists();

  Future<GroceryList?> getList(int id);

  /// Create a list. The final title is made unique by auto-suffixing
  /// " (2)", " (3)" … on collision. Returns the created list (with its id and
  /// the possibly-suffixed title).
  Future<GroceryList> createList(String title);

  /// Rename a list, keeping the title unique among the other lists.
  Future<void> renameList(int id, String title);

  /// Set a list's date (its `createdAt`). Used to backdate a forgotten trip so
  /// its expense falls in the correct month. Store a UTC timestamp.
  Future<void> setListDate(int id, DateTime date);

  Future<void> deleteList(int id);

  /// A suggested unique name for a new list, e.g. "List 3 - 11 Jul".
  /// [baseName] is the localized "List" word; [datePart] the localized date.
  Future<String> suggestListName(String baseName, String datePart);

  /// True if [title] (case-insensitive, trimmed) is free, optionally ignoring
  /// the list with [exceptId] (used when renaming).
  Future<bool> isNameAvailable(String title, {int? exceptId});

  /// Reactive stream of a single list's items.
  Stream<List<ListItem>> watchItems(int listId);

  Future<int> addItem(ListItem item);
  Future<void> updateItem(ListItem item);
  Future<void> removeItem(int itemId);

  /// Toggle bought state for an item.
  Future<void> setBought(int itemId, bool isBought);
}
