// Tests settings persistence (language survives a reload) and the
// clear-all-data operation.

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/db/app_database.dart' hide Product;
import 'package:veetubook/core/localization/app_language.dart';
import 'package:veetubook/features/catalog/data/catalog_dao.dart';
import 'package:veetubook/features/catalog/data/catalog_repository_impl.dart';
import 'package:veetubook/features/catalog/domain/entities/product.dart';
import 'package:veetubook/features/settings/domain/app_settings.dart';
import 'package:veetubook/features/settings/presentation/settings_cubit.dart';

/// In-memory settings store that mimics persistence across "reloads".
class _MemoryStore implements SettingsStore {
  AppSettings _s = const AppSettings();
  @override
  Future<AppSettings> load() async => _s;
  @override
  Future<void> saveLanguage(AppLanguage language) async =>
      _s = _s.copyWith(language: language);
  @override
  Future<void> saveCurrency(String symbol) async =>
      _s = _s.copyWith(currencySymbol: symbol);
}

void main() {
  test('language choice persists across a reload', () async {
    final store = _MemoryStore();

    final cubit = SettingsCubit(store, await store.load());
    expect(cubit.state.language, AppLanguage.english);
    await cubit.setLanguage(AppLanguage.tamil);
    await cubit.close();

    // Simulate app restart: a fresh cubit loads from the same store.
    final reloaded = await SettingsCubit.create(store);
    expect(reloaded.state.language, AppLanguage.tamil);
    await reloaded.close();
  });

  test('clearAllData empties every table', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final catalog = CatalogRepositoryImpl(CatalogDao(db));

    await catalog.saveProduct(
      Product(nameEn: 'Rice', baseQty: Decimal.one, basePricePaise: 5000),
    );
    expect(await catalog.productCount(), 1);

    await db.clearAllData();
    expect(await catalog.productCount(), 0);

    await db.close();
  });
}
