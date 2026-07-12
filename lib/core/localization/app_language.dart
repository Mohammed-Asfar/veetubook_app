import 'dart:ui';

/// The two languages veetubook supports.
enum AppLanguage {
  english('en', 'English'),
  tamil('ta', 'தமிழ்');

  const AppLanguage(this.code, this.nativeName);

  final String code;
  final String nativeName;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) =>
      AppLanguage.values.firstWhere(
        (l) => l.code == code,
        orElse: () => AppLanguage.english,
      );
}
