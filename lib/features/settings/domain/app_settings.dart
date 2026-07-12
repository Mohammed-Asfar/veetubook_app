import 'package:equatable/equatable.dart';

import '../../../core/localization/app_language.dart';

/// User-configurable app settings (persisted).
class AppSettings extends Equatable {
  const AppSettings({
    this.language = AppLanguage.english,
    this.currencySymbol = '₹',
  });

  final AppLanguage language;
  final String currencySymbol;

  AppSettings copyWith({AppLanguage? language, String? currencySymbol}) =>
      AppSettings(
        language: language ?? this.language,
        currencySymbol: currencySymbol ?? this.currencySymbol,
      );

  @override
  List<Object?> get props => [language, currencySymbol];
}

/// Persistence seam for settings — implemented over shared_preferences in the
/// data layer, kept abstract here so the cubit doesn't depend on the package.
abstract interface class SettingsStore {
  Future<AppSettings> load();
  Future<void> saveLanguage(AppLanguage language);
  Future<void> saveCurrency(String symbol);
}
