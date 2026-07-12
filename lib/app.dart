import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/settings/domain/app_settings.dart';
import 'features/settings/presentation/settings_cubit.dart';
import 'home_shell.dart';
import 'l10n/app_localizations.dart';

/// Root widget: hosts the [SettingsCubit] (created with persisted settings) and
/// rebuilds [MaterialApp] with the selected locale so UI strings + bilingual
/// data update live and survive restarts.
class VeetubookApp extends StatelessWidget {
  const VeetubookApp({super.key, required this.settingsCubit});

  final SettingsCubit settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: settingsCubit,
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            locale: settings.language.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomeShell(),
          );
        },
      ),
    );
  }
}
