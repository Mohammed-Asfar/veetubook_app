import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/month_utils.dart';
import '../../domain/entities/monthly_summary.dart';

/// A simple bar chart of monthly spend for the last few months, oldest -> newest
/// left to right, with the most recent month highlighted.
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

    // Take the most recent [maxMonths] and reverse to chronological order.
    final data = months.take(maxMonths).toList().reversed.toList();
    final theme = Theme.of(context);
    final maxPaise = data.fold<int>(0, (m, s) => s.totalPaise > m ? s.totalPaise : m);
    final maxY = maxPaise == 0 ? 1.0 : maxPaise * 1.2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            alignment: BarChartAlignment.spaceAround,
            gridData: const FlGridData(show: false),
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
                getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                    BarTooltipItem(
                  Money.format(data[groupIndex].totalPaise),
                  theme.textTheme.bodySmall!,
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
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSpacing.xs),
                        topRight: Radius.circular(AppSpacing.xs),
                      ),
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
