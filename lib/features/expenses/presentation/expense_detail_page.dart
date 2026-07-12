import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../lists/domain/entities/list_item.dart';
import '../../lists/domain/lists_repository.dart';
import '../domain/entities/expense.dart';

/// Read-only view of a past expense: the bought items that made up its total.
/// Nothing here is editable — it's a historical record.
class ExpenseDetailPage extends StatelessWidget {
  const ExpenseDetailPage({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(expense.listTitle ?? '')),
      body: StreamBuilder<List<ListItem>>(
        stream: sl<ListsRepository>().watchItems(expense.listId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          // Only the items that were actually bought contribute to the expense.
          final bought =
              snapshot.data!.where((i) => i.isBought).toList();

          return Column(
            children: [
              _Header(
                date: expense.date,
                totalPaise: expense.totalPaise,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xs,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.expenseItemsTitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.appColors.mutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: bought.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => _ReadOnlyItemTile(item: bought[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.expenseReadOnly,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.date, required this.totalPaise});

  final DateTime date;
  final int totalPaise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMMMMd('en_IN').format(date.toLocal()),
            style: theme.textTheme.bodyLarge,
          ),
          PriceText(
            totalPaise,
            style: theme.textTheme.titleLarge,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyItemTile extends StatelessWidget {
  const _ReadOnlyItemTile({required this.item});

  final ListItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BilingualText(nameTa: item.nameTa, nameEn: item.nameEn),
      subtitle: Text('${_fmtQty(item.qty)} ${item.unit}'),
      trailing: PriceText(item.linePricePaise),
    );
  }

  static String _fmtQty(Decimal d) {
    final s = d.toString();
    if (!s.contains('.')) return s;
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
