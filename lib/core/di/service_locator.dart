import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/catalog/data/catalog_dao.dart';
import '../../features/catalog/data/catalog_repository_impl.dart';
import '../../features/catalog/data/catalog_seed.dart';
import '../../features/catalog/domain/catalog_repository.dart';
import '../../features/expenses/data/expenses_dao.dart';
import '../../features/expenses/data/expenses_repository_impl.dart';
import '../../features/expenses/domain/expenses_repository.dart';
import '../../features/lists/data/lists_dao.dart';
import '../../features/lists/data/lists_repository_impl.dart';
import '../../features/lists/domain/lists_repository.dart';
import '../../features/settings/data/data_management_service.dart';
import '../../features/settings/data/prefs_settings_store.dart';
import '../../features/settings/domain/app_settings.dart';
import '../db/app_database.dart';

/// Global service locator. Register singletons here; feature blocs are created
/// per-screen via BlocProvider using these singletons.
final GetIt sl = GetIt.instance;

/// Call once at app startup (before runApp).
///
/// Tests can pass an in-memory [database] and set [reset] to re-register on a
/// fresh locator between test cases.
Future<void> setupServiceLocator({
  AppDatabase? database,
  bool reset = false,
  bool seed = true,
}) async {
  if (reset) await sl.reset();

  // Single long-lived database instance shared across the app. Registered with
  // a dispose callback so `sl.reset()` (used in tests) closes it and its
  // background connection, leaving no pending timers.
  sl.registerSingleton<AppDatabase>(
    database ?? AppDatabase(),
    dispose: (db) => db.close(),
  );

  // ---- Catalog feature ----
  sl.registerLazySingleton<CatalogDao>(() => CatalogDao(sl<AppDatabase>()));
  sl.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(sl<CatalogDao>()),
  );

  // ---- Lists feature ----
  sl.registerLazySingleton<ListsDao>(() => ListsDao(sl<AppDatabase>()));
  sl.registerLazySingleton<ListsRepository>(
    () => ListsRepositoryImpl(sl<ListsDao>()),
  );

  // ---- Expenses feature ----
  sl.registerLazySingleton<ExpensesDao>(() => ExpensesDao(sl<AppDatabase>()));
  sl.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(sl<ExpensesDao>()),
  );

  // ---- Settings feature ----
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SettingsStore>(() => PrefsSettingsStore(prefs));
  sl.registerLazySingleton<DataManagementService>(
    () => DataManagementService(sl<AppDatabase>(), sl<ExpensesRepository>()),
  );

  // Seed a starter catalog on first launch (no-op if already populated).
  if (seed) await CatalogSeeder(sl<CatalogRepository>()).seedIfEmpty();
}
