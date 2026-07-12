import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'features/settings/domain/app_settings.dart';
import 'features/settings/presentation/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  final settingsCubit = await SettingsCubit.create(sl<SettingsStore>());
  runApp(VeetubookApp(settingsCubit: settingsCubit));
}
