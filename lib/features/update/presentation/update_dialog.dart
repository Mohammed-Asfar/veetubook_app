import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../l10n/app_localizations.dart';
import '../data/update_service.dart';
import '../domain/app_release.dart';

/// Non-blocking "Update available" dialog: shows the new version + release
/// notes, with Update (opens the release page), Later (dismiss), and Skip this
/// version (never prompt for this tag again).
class UpdateDialog extends StatelessWidget {
  const UpdateDialog({
    super.key,
    required this.release,
    required this.currentVersion,
    required this.service,
  });

  final AppRelease release;
  final String currentVersion;
  final UpdateService service;

  /// Shows the dialog. Safe to call and forget.
  static Future<void> show(
    BuildContext context, {
    required AppRelease release,
    required String currentVersion,
    required UpdateService service,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => UpdateDialog(
        release: release,
        currentVersion: currentVersion,
        service: service,
      ),
    );
  }

  Future<void> _openRelease(BuildContext context) async {
    final navigator = Navigator.of(context);
    await launchUrl(
      Uri.parse(release.htmlUrl),
      mode: LaunchMode.externalApplication,
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final latest = AppVersionLabel.fromTag(release.tagName);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.system_update, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(l10n.updateTitle)),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 360),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.updateMessage(latest, currentVersion)),
              if (release.notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.updateWhatsNew,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: context.appColors.mutedText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  release.notes,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
      actionsOverflowButtonSpacing: AppSpacing.xs,
      actions: [
        TextButton(
          onPressed: () async {
            await service.skip(release.tagName);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(l10n.updateSkip),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.updateLater),
        ),
        FilledButton(
          onPressed: () => _openRelease(context),
          child: Text(l10n.updateNow),
        ),
      ],
    );
  }
}

/// Small helper to show a clean version label from a raw tag (`v1.2.0` -> `1.2.0`).
class AppVersionLabel {
  static String fromTag(String tag) {
    final t = tag.trim();
    return (t.startsWith('v') || t.startsWith('V')) ? t.substring(1) : t;
  }
}
