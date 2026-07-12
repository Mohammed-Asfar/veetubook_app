import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/month_utils.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/entities/expense.dart';
import '../domain/expenses_repository.dart';
import 'cubit/expenses_cubit.dart';
import 'expense_detail_page.dart';
import 'widgets/daily_spend_chart.dart';
import 'widgets/month_comparison_card.dart';
import 'widgets/monthly_spend_chart.dart';

/// The Expenses tab body: trip history grouped by local month, each month
/// showing its total. The parent [ExpensesCubit] must be provided above.
class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ExpensesCubit, ExpensesState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.expenses.isEmpty) {
          return EmptyState(
            icon: Icons.bar_chart_outlined,
            message: l10n.expensesEmpty,
          );
        }

        // Group expenses by local month, preserving the most-recent-first order
        // already provided by the monthly summaries.
        final byMonth = <YearMonth, List<Expense>>{};
        for (final e in state.expenses) {
          byMonth.putIfAbsent(YearMonth.fromDate(e.date), () => []).add(e);
        }

        final currentMonth = YearMonth.fromDate(DateTime.now());

        return ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: [
            MonthComparisonCard(
              months: state.months,
              currentMonth: currentMonth,
            ),
            MonthlySpendChart(months: state.months),
            _DailyChartSection(month: currentMonth),
            for (final summary in state.months) ...[
              _MonthHeader(
                label: summary.month.label(),
                totalPaise: summary.totalPaise,
              ),
              for (final e in byMonth[summary.month] ?? const <Expense>[])
                _ExpenseTile(expense: e),
            ],
          ],
        );
      },
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.label,
    required this.totalPaise,
  });

  final String label;
  final int totalPaise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: theme.textTheme.titleMedium),
          ),
          PriceText(totalPaise, color: theme.colorScheme.primary),
        ],
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.receipt_long_outlined),
      title: Text(expense.listTitle ?? ''),
      subtitle: Text(DateFormat.yMMMd('en_IN').format(expense.date.toLocal())),
      trailing: PriceText(expense.totalPaise),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ExpenseDetailPage(expense: expense),
        ),
      ),
    );
  }
}

/// Weekly-spend chart card for [month]. The chart card owns its own title.
class _DailyChartSection extends StatelessWidget {
  const _DailyChartSection({required this.month});

  final YearMonth month;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: sl<ExpensesRepository>().watchDailyTotals(month),
      builder: (context, snapshot) {
        final daily = snapshot.data;
        // Hide the section entirely until there's any spend this month.
        if (daily == null || daily.every((p) => p == 0)) {
          return const SizedBox.shrink();
        }
        return DailySpendChart(month: month, dailyPaise: daily);
      },
    );
  }
}
