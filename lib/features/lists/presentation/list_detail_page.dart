import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/units.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/domain/catalog_repository.dart';
import '../../catalog/domain/entities/category.dart';
import '../../catalog/domain/entities/product.dart';
import '../domain/entities/grocery_list.dart';
import '../domain/entities/list_item.dart';
import 'cubit/list_detail_cubit.dart';

/// Indexes list items by their catalog product id so the add-item sheet can do
/// an O(1) "is this product already on the list?" lookup per row instead of
/// scanning every item for each of the (potentially hundreds of) products.
/// Ad-hoc items (no productId) are skipped; on the rare duplicate, the first
/// item wins — matching the previous `.first` behaviour.
Map<int, ListItem> _itemsByProduct(List<ListItem> items) {
  final map = <int, ListItem>{};
  for (final it in items) {
    final pid = it.productId;
    if (pid != null) map.putIfAbsent(pid, () => it);
  }
  return map;
}

/// Shopping-mode screen: list items with check-off, quantity, per-line price,
/// and a running total. The parent [ListDetailCubit] must be provided above.
class ListDetailPage extends StatelessWidget {
  const ListDetailPage({super.key, required this.list});

  final GroceryList list;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(list.title)),
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
              _BottomBar(
                boughtPaise: state.boughtTotalPaise,
                plannedPaise: state.plannedTotalPaise,
                onAdd: () => _showAddSheet(context),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    final cubit = context.read<ListDetailCubit>();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      // Resize with the keyboard (read the sheet's own MediaQuery, not the
      // outer context, so it updates when the keyboard appears).
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: BlocProvider.value(
          value: cubit,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            maxChildSize: 0.95,
            builder: (_, controller) =>
                _AddItemSheet(scrollController: controller),
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
      // Long-press the row for Edit / Delete actions.
      child: InkWell(
        onLongPress: () => _showActions(context, cubit),
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
                onPressed: () => _bumpQty(cubit, -Units.step(item.unit)),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                visualDensity: VisualDensity.compact,
                onPressed: () => _bumpQty(cubit, Units.step(item.unit)),
              ),
              PriceText(item.linePricePaise),
            ],
          ),
        ),
      ),
    );
  }

  void _bumpQty(ListDetailCubit cubit, Decimal delta) {
    // Step by 1 for pieces/packs, 0.25 for kg/litre; never below the unit min.
    final next = Units.normalize(item.unit, item.qty + delta);
    cubit.changeQty(item, next);
  }

  /// Long-press menu: edit (price/qty) or delete this item.
  void _showActions(BuildContext context, ListDetailCubit cubit) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.editItem),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openEditor(context, cubit);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline,
                  color: context.appColors.danger),
              title: Text(
                l10n.commonDelete,
                style: TextStyle(color: context.appColors.danger),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                cubit.removeItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openEditor(BuildContext context, ListDetailCubit cubit) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      // Let the sheet grow so it can sit above the keyboard.
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ItemEditSheet(item: item),
      ),
    );
  }

  static String _fmtQty(Decimal d) {
    final s = d.toString();
    if (!s.contains('.')) return s;
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}

/// Full item editor: name (En/Ta), category, unit, quantity and price, with a
/// live line total. Saving updates this list item AND writes the changes back
/// to the source catalog product so they're the default next time.
class _ItemEditSheet extends StatefulWidget {
  const _ItemEditSheet({required this.item});

  final ListItem item;

  @override
  State<_ItemEditSheet> createState() => _ItemEditSheetState();
}

class _ItemEditSheetState extends State<_ItemEditSheet> {
  List<String> get _units => Units.all;

  late final TextEditingController _nameEn;
  late final TextEditingController _nameTa;
  late final TextEditingController _price;
  late final TextEditingController _qty;
  late String _unit;
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameEn = TextEditingController(text: item.nameEn ?? '');
    _nameTa = TextEditingController(text: item.nameTa ?? '');
    _price = TextEditingController(
      text: Money.paiseToRupees(item.unitPricePaise).toString(),
    );
    _qty = TextEditingController(text: _fmtQty(item.qty));
    _unit = _units.contains(item.unit) ? item.unit : 'unit';
    // Pre-fill category from the backing product (not snapshotted on the item).
    context.read<ListDetailCubit>().productFor(item).then((p) {
      if (mounted && p != null) setState(() => _categoryId = p.categoryId);
    });
  }

  @override
  void dispose() {
    _nameEn.dispose();
    _nameTa.dispose();
    _price.dispose();
    _qty.dispose();
    super.dispose();
  }

  int get _unitPaise =>
      Money.rupeesToPaise(Decimal.tryParse(_price.text.trim()) ?? Decimal.zero);

  Decimal get _qtyValue {
    final q = Decimal.tryParse(_qty.text.trim()) ?? Decimal.zero;
    // Whole numbers for pieces/packs; never below the unit minimum.
    return Units.normalize(_unit, q);
  }

  int get _linePaise => Money.lineTotalPaise(
        basePricePaise: _unitPaise,
        baseQty: Decimal.one,
        qty: _qtyValue,
      );

  bool get _hasName =>
      _nameEn.text.trim().isNotEmpty || _nameTa.text.trim().isNotEmpty;

  Future<void> _save() async {
    if (!_hasName) return;
    final cubit = context.read<ListDetailCubit>();
    final navigator = Navigator.of(context);
    await cubit.editItem(
      widget.item,
      nameEn: _nameEn.text.trim(),
      nameTa: _nameTa.text.trim(),
      unit: _unit,
      unitPricePaise: _unitPaise,
      qty: _qtyValue,
      categoryId: _categoryId,
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + keyboardInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editItem, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _nameEn,
            decoration: InputDecoration(labelText: l10n.nameEnglish),
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _nameTa,
            decoration: InputDecoration(labelText: l10n.nameTamil),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          _CategoryDropdown(
            value: _categoryId,
            onChanged: (id) => setState(() => _categoryId = id),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _unit,
                  decoration: InputDecoration(labelText: l10n.unit),
                  items: [
                    for (final u in _units)
                      DropdownMenuItem(value: u, child: Text(u)),
                  ],
                  onChanged: (u) {
                    if (u == null) return;
                    setState(() {
                      _unit = u;
                      // Snap the shown qty to a whole number for discrete units.
                      _qty.text = _fmtQty(_qtyValue);
                    });
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _qty,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: !Units.isDiscrete(_unit),
                  ),
                  inputFormatters: [
                    // Digits only for pieces/packs; allow a decimal point for
                    // kg/litre.
                    FilteringTextInputFormatter.allow(
                      Units.isDiscrete(_unit)
                          ? RegExp(r'[0-9]')
                          : RegExp(r'[0-9.]'),
                    ),
                  ],
                  decoration: InputDecoration(labelText: l10n.quantity),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _price,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              labelText: l10n.pricePerUnit(_unit),
              prefixText: '₹ ',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.lineTotal, style: theme.textTheme.bodyLarge),
              PriceText(_linePaise, style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.priceUpdatesCatalog, style: theme.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _hasName ? _save : null,
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }

  static String _fmtQty(Decimal d) {
    final s = d.toString();
    if (!s.contains('.')) return s;
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}

/// Category picker for the item editor, backed by the catalog's categories.
class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final language =
        AppLanguage.fromCode(Localizations.localeOf(context).languageCode);
    return StreamBuilder<List<Category>>(
      stream: sl<CatalogRepository>().watchCategories(),
      builder: (context, snapshot) {
        final categories = snapshot.data ?? const <Category>[];
        // Guard against a stale value not present in the list.
        final safeValue =
            categories.any((c) => c.id == value) ? value : null;
        return DropdownButtonFormField<int?>(
          initialValue: safeValue,
          decoration: InputDecoration(labelText: l10n.category),
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(l10n.uncategorized),
            ),
            for (final c in categories)
              DropdownMenuItem<int?>(
                value: c.id,
                child: Text(resolveBilingual(
                  language: language,
                  nameTa: c.nameTa,
                  nameEn: c.nameEn,
                )),
              ),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}

/// Pinned bottom bar holding the running totals and the primary "Add" action.
///
/// This lives in the layout (not as a floating button), so it never overlaps
/// the list or the totals. [SafeArea] keeps it above the device's bottom inset.
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.boughtPaise,
    required this.plannedPaise,
    required this.onAdd,
  });

  final int boughtPaise;
  final int plannedPaise;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
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
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: Text(l10n.addFromCatalog),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Search-first "add item" sheet.
///
/// A search field filters the catalog live (Tamil OR English). Each product has
/// a + to add; once on the list it shows its quantity + an X to remove, and the
/// sheet stays open so several items can be added in one go. When the query
/// matches no product, a `Create "name"` row saves a new catalog product and
/// adds it to the list.
class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet({required this.scrollController});

  final ScrollController scrollController;

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce so we don't refilter on every keystroke (PRD edge case).
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  bool _matches(Product p, String q) {
    final lower = q.toLowerCase();
    return (p.nameEn ?? '').toLowerCase().contains(lower) ||
        (p.nameTa ?? '').contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchProducts,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          TabBar(
            tabs: [
              Tab(text: l10n.tabAll),
              Tab(text: l10n.tabRecent),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _AllTab(
                  scrollController: widget.scrollController,
                  query: _query,
                  matches: _matches,
                  onCreate: (name) => _createAndAdd(context, name),
                ),
                _RecentTab(query: _query, matches: _matches),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createAndAdd(BuildContext context, String name) async {
    final detailCubit = context.read<ListDetailCubit>();
    final catalog = sl<CatalogRepository>();
    // Reuse an existing product if one matches by name (case-insensitive) so we
    // never create "milk" and "Milk" as separate catalog entries.
    var product = await catalog.findByName(name);
    if (product == null) {
      final created = Product(nameEn: name.trim(), baseQty: Decimal.one);
      final id = await catalog.saveProduct(created);
      product = created.copyWith(id: id);
    }
    await detailCubit.addFromProduct(product, Decimal.one);
    _searchController.clear();
    if (mounted) setState(() => _query = '');
  }
}

/// Shared list of product rows with add/added state, driven by a product stream.
/// [emptyMessage] is shown when the (filtered) stream has no products.
class _ProductAddList extends StatelessWidget {
  const _ProductAddList({
    required this.stream,
    required this.query,
    required this.matches,
    required this.emptyMessage,
  });

  final Stream<List<Product>> stream;
  final String query;
  final bool Function(Product, String) matches;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final detailCubit = context.read<ListDetailCubit>();
    return StreamBuilder<List<Product>>(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = snap.data!;
        final filtered = query.isEmpty
            ? all
            : all.where((p) => matches(p, query)).toList();

        if (filtered.isEmpty) {
          return EmptyState(
            icon: Icons.inbox_outlined,
            message: emptyMessage,
          );
        }

        // Rows reflect current list items so the add/added state stays live.
        return BlocBuilder<ListDetailCubit, ListDetailState>(
          builder: (context, state) {
            // Build a productId -> item lookup once per rebuild so each row is
            // an O(1) map read instead of an O(items) scan (matters with a
            // large catalog).
            final byProduct = _itemsByProduct(state.items);
            return ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = filtered[i];
                final existing = byProduct[p.id];
                return _ProductAddRow(
                  product: p,
                  existing: existing,
                  onAdd: () => detailCubit.addFromProduct(p, Decimal.one),
                  onRemove: existing == null
                      ? null
                      : () => detailCubit.removeItem(existing),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// "All" tab: the full searchable catalog, with a `Create "name"` row when the
/// search matches no product (and an "already exists" banner when it does).
class _AllTab extends StatelessWidget {
  const _AllTab({
    required this.scrollController,
    required this.query,
    required this.matches,
    required this.onCreate,
  });

  final ScrollController scrollController;
  final String query;
  final bool Function(Product, String) matches;
  final ValueChanged<String> onCreate;

  @override
  Widget build(BuildContext context) {
    final detailCubit = context.read<ListDetailCubit>();
    return StreamBuilder<List<Product>>(
      stream: sl<CatalogRepository>().watchProducts(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = snap.data!;
        final filtered = query.isEmpty
            ? all
            : all.where((p) => matches(p, query)).toList();

        final q = query.trim().toLowerCase();
        final exactExists = q.isNotEmpty &&
            all.any((p) =>
                (p.nameEn ?? '').trim().toLowerCase() == q ||
                (p.nameTa ?? '').trim().toLowerCase() == q);
        final canCreate = query.isNotEmpty && filtered.isEmpty && !exactExists;

        return BlocBuilder<ListDetailCubit, ListDetailState>(
          builder: (context, state) {
            // O(1) per-row lookup instead of scanning items for every product.
            final byProduct = _itemsByProduct(state.items);
            return Column(
              children: [
                if (exactExists) _AlreadyExistsBanner(name: query.trim()),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: filtered.length + (canCreate ? 1 : 0),
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      if (canCreate && i == 0) {
                        return _CreateProductRow(
                          name: query,
                          onTap: () => onCreate(query),
                        );
                      }
                      final p = filtered[i - (canCreate ? 1 : 0)];
                      final existing = byProduct[p.id];
                      return _ProductAddRow(
                        product: p,
                        existing: existing,
                        onAdd: () =>
                            detailCubit.addFromProduct(p, Decimal.one),
                        onRemove: existing == null
                            ? null
                            : () => detailCubit.removeItem(existing),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// "Recent" tab: products recently added to any list.
class _RecentTab extends StatelessWidget {
  const _RecentTab({required this.query, required this.matches});

  final String query;
  final bool Function(Product, String) matches;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _ProductAddList(
      stream: sl<CatalogRepository>().watchRecentProducts(),
      query: query,
      matches: matches,
      emptyMessage: l10n.recentEmpty,
    );
  }
}

/// Shown when the typed name already names a catalog product, so the user knows
/// it exists (rather than being offered a duplicate "Create").
class _AlreadyExistsBanner extends StatelessWidget {
  const _AlreadyExistsBanner({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.secondary.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: context.appColors.mutedText),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.productAlreadyExists(name),
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// A catalog product row in the add sheet: + to add, or qty + X once added.
class _ProductAddRow extends StatelessWidget {
  const _ProductAddRow({
    required this.product,
    required this.existing,
    required this.onAdd,
    this.onRemove,
  });

  final Product product;
  final ListItem? existing;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAdded = existing != null;
    return ListTile(
      // The whole row is tappable to add another of this product; the leading
      // icon is just an affordance, not a separate button.
      onTap: onAdd,
      leading: Icon(
        Icons.add_circle,
        color: isAdded
            ? theme.colorScheme.primary
            : context.appColors.mutedText,
      ),
      title: BilingualText(nameTa: product.nameTa, nameEn: product.nameEn),
      trailing: isAdded
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_fmtQty(existing!.qty)} × ${existing!.unit}',
                  style: theme.textTheme.bodySmall,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: context.appColors.danger),
                  onPressed: onRemove,
                ),
              ],
            )
          : (product.basePricePaise > 0
              ? PriceText(product.basePricePaise)
              : null),
    );
  }

  static String _fmtQty(Decimal d) {
    final s = d.toString();
    if (!s.contains('.')) return s;
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}

/// The `Create "name"` row shown when the search matches no product.
class _CreateProductRow extends StatelessWidget {
  const _CreateProductRow({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      title: Text(
        l10n.createProductNamed(name),
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      onTap: onTap,
    );
  }
}
