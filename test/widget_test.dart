// Verifies the SettingsCubit drives MaterialApp's locale and re-renders
// localized strings live, without spinning up the DB-backed home shell (drift's
// background isolate doesn't settle under FakeAsync). The data layer is covered
// by the *_test.dart files; the full shell is exercised via `flutter run`.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/localization/app_language.dart';
import 'package:veetubook/features/settings/domain/app_settings.dart';
import 'package:veetubook/features/settings/presentation/settings_cubit.dart';
import 'package:veetubook/l10n/app_localizations.dart';

/// In-memory [SettingsStore] so the test doesn't touch shared_preferences.
class _FakeStore implements SettingsStore {
  AppSettings _s = const AppSettings();
  @override
  Future<AppSettings> load() async => _s;
  @override
  Future<void> saveLanguage(AppLanguage language) async =>
      _s = _s.copyWith(language: language);
  @override
  Future<void> saveCurrency(String symbol) async =>
      _s = _s.copyWith(currencySymbol: symbol);
  @override
  Future<void> saveAutoGenerateListNames(bool enabled) async =>
      _s = _s.copyWith(autoGenerateListNames: enabled);
}

void main() {
  testWidgets('language toggle switches localized strings live',
      (WidgetTester tester) async {
    final cubit = SettingsCubit(_FakeStore(), const AppSettings());
    addTearDown(cubit.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: BlocBuilder<SettingsCubit, AppSettings>(
          builder: (context, settings) => MaterialApp(
            locale: settings.language.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Scaffold(
                  appBar: AppBar(title: Text(l10n.navLists)),
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<SettingsCubit>().toggleLanguage(),
                      child: Text(l10n.settingsLanguage),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Starts in English.
    expect(find.text('Lists'), findsOneWidget);

    // Toggle to Tamil.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('பட்டியல்கள்'), findsOneWidget);
    expect(find.text('Lists'), findsNothing);
  });
}
