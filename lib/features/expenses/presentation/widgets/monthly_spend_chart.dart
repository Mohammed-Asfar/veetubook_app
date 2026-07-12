import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/month_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/monthly_summary.dart';
import 'chart_card.dart';

/// Bar chart of monthly spend for the last few months, oldest -> newest left to
/// right, with the most recent month highlighted — in a titled chart card.
class MonthlySpendChart extends StatelessWidget {
  const MonthlySpendChart({
    super.key,
    required this.months,
    this.maxMonths = 6,
  });

  /// Monthly summaries, most recent first (as produced by the repository).
  final List<MonthlySummary> months;
  final int maxMonths;

  @override
  Widget build(BuildContext context) {
    if (months.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    // Take the most recent [maxMonths] and reverse to chronological order.
    final data = months.take(maxMonths).toList().reversed.toList();
    final theme = Theme.of(context);
    final maxPaise = data.fold<int>(0, (m, s) => s.totalPaise > m ? s.totalPaise : m);
    final maxY = maxPaise == 0 ? 1.0 : maxPaise * 1.2;
    final gridColor = theme.colorScheme.onSurface.withValues(alpha: 0.08);

    // Trend caption from the latest two months.
    String? caption;
    IconData? captionIcon;
    if (data.length >= 2) {
      final prev = data[data.length - 2].totalPaise;
      final curr = data.last.totalPaise;
      if (prev > 0) {
        final pct = (curr - prev) / prev * 100;
        final up = pct > 0;
        caption = up
            ? l10n.trendingUp(pct.abs().toStringAsFixed(1))
            : l10n.trendingDown(pct.abs().toStringAsFixed(1));
        captionIcon = up ? Icons.trending_up : Icons.trending_down;
      }
    }

    final subtitle = data.length >= 2
        ? '${data.first.month.label()} – ${data.last.month.label()}'
        : data.first.month.label();

    return ChartCard(
      title: l10n.monthlySpend,
      subtitle: subtitle,
      caption: caption,
      captionIcon: captionIcon,
      footnote: l10n.showingLastMonths(data.length),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            // Center the bars with a fixed gap so a few months don't get
            // spread across the whole width.
            alignment: BarChartAlignment.center,
            groupsSpace: AppSpacing.xl,
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
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= data.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        _shortMonth(data[i].month),
                        style: theme.textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => theme.colorScheme.surface,
                tooltipBorder: BorderSide(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                ),
                tooltipBorderRadius:
                    BorderRadius.circular(AppSpacing.radiusSm),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                    BarTooltipItem(
                  '${data[groupIndex].month.label()}\n',
                  theme.textTheme.bodySmall!.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: Money.format(data[groupIndex].totalPaise),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < data.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: data[i].totalPaise.toDouble(),
                      width: 18,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                      color: i == data.length - 1
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withValues(alpha: 0.4),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _shortMonth(YearMonth m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[m.month - 1];
  }
}
