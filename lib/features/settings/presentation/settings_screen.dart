import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../onboarding/presentation/onboarding_page.dart';
import '../../update/data/update_service.dart';
import '../../update/presentation/update_dialog.dart';
import '../data/data_management_service.dart';
import '../domain/app_settings.dart';
import 'settings_cubit.dart';

/// The Settings tab: language, currency, and data management (export / clear).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) {
        return ListView(
          children: [
            _SectionHeader(l10n.settingsLanguage),
            RadioGroup<AppLanguage>(
              groupValue: settings.language,
              onChanged: (lang) {
                if (lang != null) {
                  context.read<SettingsCubit>().setLanguage(lang);
                }
              },
              child: Column(
                children: [
                  RadioListTile<AppLanguage>(
                    value: AppLanguage.english,
                    title: Text(l10n.languageEnglish),
                  ),
                  RadioListTile<AppLanguage>(
                    value: AppLanguage.tamil,
                    title: Text(l10n.languageTamil),
                  ),
                ],
              ),
            ),
            const Divider(),
            _SectionHeader(l10n.sectionLists),
            SwitchListTile(
              secondary: const Icon(Icons.drive_file_rename_outline),
              title: Text(l10n.settingsAutoName),
              subtitle: Text(l10n.settingsAutoNameHint),
              value: settings.autoGenerateListNames,
              onChanged: (v) =>
                  context.read<SettingsCubit>().setAutoGenerateListNames(v),
            ),
            const Divider(),
            _SectionHeader(l10n.sectionData),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text(l10n.settingsExport),
              subtitle: Text(l10n.settingsExportHint),
              onTap: () => _export(context),
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: context.appColors.danger),
              title: Text(
                l10n.settingsClearData,
                style: TextStyle(color: context.appColors.danger),
              ),
              subtitle: Text(l10n.settingsClearDataHint),
              onTap: () => _clearData(context),
            ),
            const Divider(),
            _SectionHeader(l10n.sectionHelp),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(l10n.settingsHowItWorks),
              subtitle: Text(l10n.settingsHowItWorksHint),
              onTap: () => _showOnboarding(context),
            ),
            ListTile(
              leading: const Icon(Icons.system_update),
              title: Text(l10n.settingsCheckUpdate),
              subtitle: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snap) => Text(
                  l10n.settingsCheckUpdateHint(snap.data?.version ?? '—'),
                ),
              ),
              onTap: () => _checkUpdate(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkUpdate(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final service = sl<UpdateService>();
    final release = await service.checkForUpdate();
    if (!context.mounted) return;

    if (release == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.updateUpToDate)));
      return;
    }
    final info = await PackageInfo.fromPlatform();
    if (!context.mounted) return;
    await UpdateDialog.show(
      context,
      release: release,
      currentVersion: info.version,
      service: service,
    );
  }

  void _showOnboarding(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => OnboardingPage(onDone: () => Navigator.of(ctx).pop()),
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await sl<DataManagementService>().exportExpensesCsv();
    messenger.showSnackBar(SnackBar(content: Text(l10n.exportDone)));
  }

  Future<void> _clearData(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showConfirmDialog(
      context,
      title: l10n.settingsClearData,
      message: l10n.clearDataConfirm,
      confirmLabel: l10n.settingsClearData,
    );
    if (!ok) return;
    await sl<DataManagementService>().clearAllData();
    messenger.showSnackBar(SnackBar(content: Text(l10n.clearDone)));
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.appColors.mutedText,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
