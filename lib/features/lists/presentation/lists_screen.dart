import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../catalog/domain/catalog_repository.dart';
import '../../expenses/domain/expenses_repository.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../domain/entities/grocery_list.dart';
import '../domain/lists_repository.dart';
import 'cubit/list_detail_cubit.dart';
import 'cubit/lists_cubit.dart';
import 'list_detail_page.dart';

/// The Lists tab body: all grocery lists with search + create/rename/delete.
class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  /// Create a new list. If auto-naming is on, generates a unique name and opens
  /// it immediately; otherwise prompts for a name. Both paths are uniqued.
  static Future<void> promptCreateList(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ListsCubit>();
    final autoName =
        context.read<SettingsCubit>().state.autoGenerateListNames;

    String? title;
    if (autoName) {
      final datePart = DateFormat.MMMd(
        Localizations.localeOf(context).toString(),
      ).format(DateTime.now());
      title = await cubit.suggestName(l10n.listNameBase, datePart);
    } else {
      title = await _promptForName(context, l10n.newList, l10n.listName);
    }
    if (title == null || title.trim().isEmpty) return;

    final created = await cubit.createList(title);
    if (context.mounted) _openList(context, created);
  }

  static void _openList(BuildContext context, GroceryList list) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ListDetailCubit(
            sl<ListsRepository>(),
            sl<ExpensesRepository>(),
            sl<CatalogRepository>(),
            list.id!,
          ),
          child: ListDetailPage(list: list),
        ),
      ),
    );
  }

  static Future<String?> _promptForName(
    BuildContext context,
    String title,
    String label, {
    String initial = '',
  }) {
    final controller = TextEditingController(text: initial);
    final l10n = AppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: label),
          onSubmitted: (v) => Navigator.of(context).pop(v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
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
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ListsCubit, ListsState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.lists.isEmpty) {
          return EmptyState(
            icon: Icons.list_alt,
            message: l10n.listsEmpty,
            action: FilledButton.icon(
              onPressed: () => ListsScreen.promptCreateList(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.newList),
            ),
          );
        }

        final visible = _query.isEmpty
            ? state.lists
            : state.lists
                .where((l) =>
                    l.title.toLowerCase().contains(_query.toLowerCase()))
                .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.searchLists,
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off,
                      message: l10n.listsNoMatch,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      itemCount: visible.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) => _ListTile(list: visible[i]),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.list});

  final GroceryList list;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.receipt_long_outlined),
      title: Text(list.title),
      subtitle: Text(_formatDate(list.createdAt)),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          final cubit = context.read<ListsCubit>();
          if (value == 'rename') {
            final name = await ListsScreen._promptForName(
              context,
              l10n.renameList,
              l10n.listName,
              initial: list.title,
            );
            if (name != null && name.isNotEmpty) {
              await cubit.renameList(list.id!, name);
            }
          } else if (value == 'date') {
            final picked = await showDatePicker(
              context: context,
              initialDate: list.createdAt.toLocal(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              helpText: l10n.changeDate,
            );
            if (picked != null) {
              await cubit.setListDate(list.id!, picked);
            }
          } else if (value == 'delete') {
            final ok = await showConfirmDialog(
              context,
              title: l10n.deleteListConfirm,
              message: '',
              confirmLabel: l10n.commonDelete,
            );
            if (ok) await cubit.deleteList(list.id!);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'rename', child: Text(l10n.renameList)),
          PopupMenuItem(value: 'date', child: Text(l10n.changeDate)),
          PopupMenuItem(value: 'delete', child: Text(l10n.commonDelete)),
        ],
      ),
      onTap: () => ListsScreen._openList(context, list),
    );
  }

  static String _formatDate(DateTime utc) {
    final d = utc.toLocal();
    return '${d.day}/${d.month}/${d.year}';
  }
}
