import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_theme_extension.dart';

/// Reusable confirmation dialog for destructive actions (delete list,
/// clear all data). PRD: destructive actions must confirm.
///
/// Returns `true` if the user confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  bool destructive = true,
}) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: context.appColors.danger,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel ?? l10n.commonConfirm),
        ),
      ],
    ),
  );
  return result ?? false;
}
