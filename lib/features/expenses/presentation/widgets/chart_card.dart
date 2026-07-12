import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// A card wrapper for a chart: title, optional subtitle, the chart body, and an
/// optional caption line — styled like the shadcn-style reference.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.caption,
    this.captionIcon,
    this.footnote,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  /// Bold trend line (e.g. "Trending up by 5.2% this month").
  final String? caption;
  final IconData? captionIcon;

  /// Muted description line under the caption (e.g. "Showing total spend…").
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = context.appColors.mutedText;

    return Card(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: context.appColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: muted)),
            ],
            const SizedBox(height: AppSpacing.lg),
            child,
            if (caption != null) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      caption!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (captionIcon != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(captionIcon, size: 16),
                  ],
                ],
              ),
            ],
            if (footnote != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                footnote!,
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
