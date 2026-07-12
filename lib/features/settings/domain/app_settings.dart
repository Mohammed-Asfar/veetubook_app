import 'package:equatable/equatable.dart';

import '../../../core/localization/app_language.dart';

/// User-configurable app settings (persisted).
class AppSettings extends Equatable {
  const AppSettings({
    this.language = AppLanguage.english,
    this.currencySymbol = '₹',
    this.autoGenerateListNames = true,
  });

  final AppLanguage language;
  final String currencySymbol;

  /// When true, new lists get an auto-generated unique name; when false, the
  /// user is prompted to name each list.
  final bool autoGenerateListNames;

  AppSettings copyWith({
    AppLanguage? language,
    String? currencySymbol,
    bool? autoGenerateListNames,
  }) =>
      AppSettings(
        language: language ?? this.language,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        autoGenerateListNames:
            autoGenerateListNames ?? this.autoGenerateListNames,
      );

  @override
  List<Object?> get props =>
      [language, currencySymbol, autoGenerateListNames];
}

/// Persistence seam for settings — implemented over shared_preferences in the
/// data layer, kept abstract here so the cubit doesn't depend on the package.
abstract interface class SettingsStore {
  Future<AppSettings> load();
  Future<void> saveLanguage(AppLanguage language);
  Future<void> saveCurrency(String symbol);
  Future<void> saveAutoGenerateListNames(bool enabled);
}
