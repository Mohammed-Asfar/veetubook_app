import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_language.dart';
import '../domain/app_settings.dart';

/// Holds the persisted [AppSettings] and drives the app locale.
///
/// Replaces the old LanguageCubit: emitting a new state rebuilds MaterialApp
/// with the new locale (re-rendering UI + BilingualText live), and every change
/// is written through to the [SettingsStore] so it survives a restart.
class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._store, AppSettings initial) : super(initial);

  final SettingsStore _store;

  /// Load persisted settings, then create the cubit (used at startup).
  static Future<SettingsCubit> create(SettingsStore store) async {
    final initial = await store.load();
    return SettingsCubit(store, initial);
  }

  Future<void> setLanguage(AppLanguage language) async {
    emit(state.copyWith(language: language));
    await _store.saveLanguage(language);
  }

  void toggleLanguage() => setLanguage(
        state.language == AppLanguage.english
            ? AppLanguage.tamil
            : AppLanguage.english,
      );

  Future<void> setCurrency(String symbol) async {
    emit(state.copyWith(currencySymbol: symbol));
    await _store.saveCurrency(symbol);
  }

  Future<void> setAutoGenerateListNames(bool enabled) async {
    emit(state.copyWith(autoGenerateListNames: enabled));
    await _store.saveAutoGenerateListNames(enabled);
  }
}
