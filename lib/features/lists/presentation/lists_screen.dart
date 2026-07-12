import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../expenses/domain/expenses_repository.dart';
import '../domain/entities/grocery_list.dart';
import '../domain/lists_repository.dart';
import 'cubit/list_detail_cubit.dart';
import 'cubit/lists_cubit.dart';
import 'list_detail_page.dart';

/// The Lists tab body: all grocery lists with create/rename/delete.
class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

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
              onPressed: () => promptCreateList(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.newList),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: state.lists.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) => _ListTile(list: state.lists[i]),
        );
      },
    );
  }

  /// Shows a dialog to name and create a new list, then opens it.
  static Future<void> promptCreateList(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ListsCubit>();
    final title = await _promptForName(context, l10n.newList, l10n.listName);
    if (title == null || title.isEmpty) return;
    final id = await cubit.createList(title);
    if (context.mounted) {
      _openList(context, GroceryList(id: id, title: title, createdAt: DateTime.now()));
    }
  }

  static void _openList(BuildContext context, GroceryList list) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ListDetailCubit(
            sl<ListsRepository>(),
            sl<ExpensesRepository>(),
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
