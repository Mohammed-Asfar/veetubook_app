import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/month_utils.dart';
import '../../../../l10n/app_localizations.dart';
import 'chart_card.dart';

/// Weekly spend bar chart for a month: the month's days are grouped into weeks
/// (1–7, 8–14, …) and each week is one bar. Weeks with no spend show a faint
/// full-height placeholder so the month's shape is always visible.
class DailySpendChart extends StatelessWidget {
  const DailySpendChart({
    super.key,
    required this.month,
    required this.dailyPaise,
  });

  final YearMonth month;

  /// Paise per day, index 0 = day 1. Length == days in the month.
  final List<int> dailyPaise;

  /// Aggregate daily totals into 7-day weeks. Returns a list of
  /// (startDay, endDay, totalPaise) per week.
  List<(int, int, int)> _weeks() {
    final weeks = <(int, int, int)>[];
    final days = dailyPaise.length;
    for (var start = 1; start <= days; start += 7) {
      final end = (start + 6) > days ? days : start + 6;
      var total = 0;
      for (var d = start; d <= end; d++) {
        total += dailyPaise[d - 1];
      }
      weeks.add((start, end, total));
    }
    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    if (dailyPaise.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final weeks = _weeks();
    final maxPaise = weeks.fold<int>(0, (m, w) => w.$3 > m ? w.$3 : m);
    final maxY = maxPaise == 0 ? 1.0 : maxPaise * 1.2;
    final placeholder = theme.colorScheme.onSurface.withValues(alpha: 0.08);
    final divider = theme.colorScheme.onSurface.withValues(alpha: 0.12);
    final gridColor = theme.colorScheme.onSurface.withValues(alpha: 0.08);

    return ChartCard(
      title: l10n.dailySpendThisMonth,
      subtitle: month.label(),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            alignment: BarChartAlignment.spaceAround,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: gridColor, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= weeks.length) {
                      return const SizedBox.shrink();
                    }
                    final (start, end, _) = weeks[i];
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text('$start–$end', style: theme.textTheme.bodySmall),
                    );
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => theme.colorScheme.surface,
                tooltipBorder: BorderSide(color: divider),
                tooltipBorderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final (start, end, total) = weeks[groupIndex];
                  if (total == 0) return null;
                  return BarTooltipItem(
                    '${month.label()} $start–$end\n',
                    theme.textTheme.bodySmall!.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: Money.format(total),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            barGroups: [
              for (var i = 0; i < weeks.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: weeks[i].$3 == 0 ? maxY : weeks[i].$3.toDouble(),
                      width: 22,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                      color: weeks[i].$3 == 0
                          ? placeholder
                          : theme.colorScheme.primary,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
