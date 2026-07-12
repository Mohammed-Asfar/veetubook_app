import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/domain/catalog_repository.dart';
import '../../catalog/domain/entities/product.dart';
import '../domain/entities/grocery_list.dart';
import '../domain/entities/list_item.dart';
import 'cubit/list_detail_cubit.dart';

/// Shopping-mode screen: list items with check-off, quantity, per-line price,
/// and a running total. The parent [ListDetailCubit] must be provided above.
class ListDetailPage extends StatelessWidget {
  const ListDetailPage({super.key, required this.list});

  final GroceryList list;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(list.title),
        actions: [
          BlocBuilder<ListDetailCubit, ListDetailState>(
            builder: (context, state) => TextButton.icon(
              onPressed: state.items.any((i) => i.isBought)
                  ? () => _finishTrip(context)
                  : null,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(l10n.finishTrip),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ListDetailCubit, ListDetailState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: state.items.isEmpty
                    ? EmptyState(
                        icon: Icons.add_shopping_cart,
                        message: l10n.listItemsEmpty,
                      )
                    : ListView.separated(
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) =>
                            _ItemTile(item: state.items[i]),
                      ),
              ),
              _TotalsBar(
                boughtPaise: state.boughtTotalPaise,
                plannedPaise: state.plannedTotalPaise,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addFromCatalog),
      ),
    );
  }

  Future<void> _finishTrip(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ListDetailCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final ok = await showConfirmDialog(
      context,
      title: l10n.finishTrip,
      message: l10n.finishTripConfirm,
      confirmLabel: l10n.finishTrip,
      destructive: false,
    );
    if (!ok) return;
    await cubit.finishTrip();
    messenger.showSnackBar(SnackBar(content: Text(l10n.tripFinished)));
    navigator.pop();
  }

  void _showAddSheet(BuildContext context) {
    final cubit = context.read<ListDetailCubit>();
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (_, controller) => _AddFromCatalogSheet(
            scrollController: controller,
            title: l10n.addFromCatalog,
          ),
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item});

  final ListItem item;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ListDetailCubit>();
    final boughtColor = context.appColors.boughtOverlay;
    final strike = item.isBought
        ? TextStyle(
            decoration: TextDecoration.lineThrough,
            color: boughtColor,
          )
        : null;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: context.appColors.danger,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => cubit.removeItem(item),
      child: CheckboxListTile(
        value: item.isBought,
        onChanged: (v) => cubit.setBought(item, v ?? false),
        controlAffinity: ListTileControlAffinity.leading,
        title: BilingualText(
          nameTa: item.nameTa,
          nameEn: item.nameEn,
          style: strike,
        ),
        subtitle: Text('${_fmtQty(item.qty)} ${item.unit}'),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              visualDensity: VisualDensity.compact,
              onPressed: () => _bumpQty(cubit, item, Decimal.parse('-0.25')),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              visualDensity: VisualDensity.compact,
              onPressed: () => _bumpQty(cubit, item, Decimal.parse('0.25')),
            ),
            PriceText(item.linePricePaise),
          ],
        ),
      ),
    );
  }

  void _bumpQty(ListDetailCubit cubit, ListItem item, Decimal delta) {
    var next = item.qty + delta;
    if (next < Decimal.zero) next = Decimal.zero;
    cubit.changeQty(item, next);
  }

  static String _fmtQty(Decimal d) {
    final s = d.toString();
    if (!s.contains('.')) return s;
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}

class _TotalsBar extends StatelessWidget {
  const _TotalsBar({required this.boughtPaise, required this.plannedPaise});

  final int boughtPaise;
  final int plannedPaise;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Material(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.plannedTotal, style: theme.textTheme.bodySmall),
                PriceText(plannedPaise, style: theme.textTheme.bodyLarge),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(l10n.runningTotal, style: theme.textTheme.bodySmall),
                PriceText(boughtPaise),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet that lists catalog products to add to the current list. Tapping
/// a product adds it with a default quantity of 1 (auto-calc snapshots price).
class _AddFromCatalogSheet extends StatelessWidget {
  const _AddFromCatalogSheet({
    required this.scrollController,
    required this.title,
  });

  final ScrollController scrollController;
  final String title;

  @override
  Widget build(BuildContext context) {
    final detailCubit = context.read<ListDetailCubit>();
    return FutureBuilder<List<Product>>(
      future: sl<CatalogRepository>().watchProducts().first,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = snapshot.data!;
        return ListView.separated(
          controller: scrollController,
          itemCount: products.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final p = products[i];
            return ListTile(
              title: BilingualText(nameTa: p.nameTa, nameEn: p.nameEn),
              subtitle: Text(p.unit),
              trailing: PriceText(p.basePricePaise),
              onTap: () async {
                await detailCubit.addFromProduct(p, Decimal.one);
                if (context.mounted) Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }
}
