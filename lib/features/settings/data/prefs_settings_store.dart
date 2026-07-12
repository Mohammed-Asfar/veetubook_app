import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/localization/app_language.dart';
import '../domain/app_settings.dart';

/// [SettingsStore] backed by shared_preferences.
class PrefsSettingsStore implements SettingsStore {
  PrefsSettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kLanguage = 'settings.language';
  static const _kCurrency = 'settings.currency';

  @override
  Future<AppSettings> load() async {
    return AppSettings(
      language: AppLanguage.fromCode(_prefs.getString(_kLanguage)),
      currencySymbol: _prefs.getString(_kCurrency) ?? '₹',
    );
  }

  @override
  Future<void> saveLanguage(AppLanguage language) =>
      _prefs.setString(_kLanguage, language.code);

  @override
  Future<void> saveCurrency(String symbol) =>
      _prefs.setString(_kCurrency, symbol);
}
