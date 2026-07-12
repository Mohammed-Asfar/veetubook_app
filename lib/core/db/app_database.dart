import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// The single drift database for veetubook.
///
/// One long-lived instance is created and shared via DI (get_it) — never
/// reopened per call (PRD performance note).
@DriftDatabase(
  tables: [Categories, Products, GroceryLists, ListItems, Expenses],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  /// Delete all user data (used by Settings → Clear all data). Runs in a
  /// transaction so it's all-or-nothing. Categories are cleared too, so the
  /// seeder will repopulate a fresh starter catalog on next launch.
  Future<void> clearAllData() {
    return transaction(() async {
      // Order respects FKs: children before parents.
      await delete(listItems).go();
      await delete(expenses).go();
      await delete(groceryLists).go();
      await delete(products).go();
      await delete(categories).go();
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          // Enforce foreign keys (ON DELETE SET NULL / CASCADE) at runtime.
          await customStatement('PRAGMA foreign_keys = ON');
        },
        // Future schema changes (e.g. stores table) add onUpgrade steps here.
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'veetubook.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
