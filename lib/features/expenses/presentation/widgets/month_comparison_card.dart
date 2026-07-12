import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/month_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/monthly_summary.dart';

/// Month-over-month comparison card for the latest month with data.
///
/// Handles the PRD edge cases:
/// - No prior month  -> shows "no prior data" (never divides by zero).
/// - Current (ongoing) month -> labels the total "so far this month".
class MonthComparisonCard extends StatelessWidget {
  const MonthComparisonCard({
    super.key,
    required this.months,
    required this.currentMonth,
  });

  /// Monthly summaries, most recent first.
  final List<MonthlySummary> months;

  /// The device's current local month (passed in so the widget stays pure).
  final YearMonth currentMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (months.isEmpty) return const SizedBox.shrink();

    final latest = months.first;
    final prev = _totalFor(latest.month.previous);
    final comparison = MonthComparison(
      current: latest.month,
      previous: latest.month.previous,
      currentTotalPaise: latest.totalPaise,
      previousTotalPaise: prev,
    );

    final isCurrentMonth = latest.month == currentMonth;
    final pct = comparison.percentChange;

    return Card(
      margin: const EdgeInsets.all(AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              latest.month.label(),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              isCurrentMonth ? l10n.soFarThisMonth : l10n.monthlySpend,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            PriceText(latest.totalPaise, style: theme.textTheme.displayLarge),
            const SizedBox(height: AppSpacing.md),
            _ChangeChip(comparison: comparison, pct: pct),
          ],
        ),
      ),
    );
  }

  int _totalFor(YearMonth month) {
    for (final m in months) {
      if (m.month == month) return m.totalPaise;
    }
    return 0;
  }
}

class _ChangeChip extends StatelessWidget {
  const _ChangeChip({required this.comparison, required this.pct});

  final MonthComparison comparison;
  final double? pct;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // No prior data -> avoid a misleading arrow; state it plainly.
    if (pct == null) {
      return Text(
        l10n.noPriorData,
        style: theme.textTheme.bodySmall,
      );
    }

    // Icon + text (not color alone) for accessibility (PRD).
    final up = comparison.isUp;
    final color = up ? context.appColors.priceUp : context.appColors.priceDown;
    final icon = up ? Icons.trending_up : Icons.trending_down;
    final label = '${pct!.abs().toStringAsFixed(0)}% ${l10n.vsPreviousMonth}';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: color)),
      ],
    );
  }
}
