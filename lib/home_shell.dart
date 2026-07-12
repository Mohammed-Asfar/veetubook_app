import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/widgets/widgets.dart';
import 'features/catalog/domain/catalog_repository.dart';
import 'features/catalog/presentation/catalog_screen.dart';
import 'features/catalog/presentation/cubit/catalog_cubit.dart';
import 'features/expenses/domain/expenses_repository.dart';
import 'features/expenses/presentation/cubit/expenses_cubit.dart';
import 'features/expenses/presentation/expenses_screen.dart';
import 'features/lists/domain/lists_repository.dart';
import 'features/lists/presentation/cubit/lists_cubit.dart';
import 'features/lists/presentation/lists_screen.dart';
import 'features/settings/presentation/settings_cubit.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'l10n/app_localizations.dart';

/// The main app shell with the four-tab bottom navigation from the PRD:
/// Lists · Products · Expenses · Settings.
///
/// Each tab currently shows a placeholder empty-state; feature screens replace
/// these as milestones M1–M5 land.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // Provide the feature cubits at the shell level so they survive tab
    // switches and the FABs can reach them.
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatalogCubit>(
          create: (_) => CatalogCubit(sl<CatalogRepository>()),
        ),
        BlocProvider<ListsCubit>(
          create: (_) =>
              ListsCubit(sl<ListsRepository>(), sl<ExpensesRepository>()),
        ),
        BlocProvider<ExpensesCubit>(
          create: (_) => ExpensesCubit(sl<ExpensesRepository>()),
        ),
      ],
      child: Builder(builder: _buildScaffold),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final tabs = <_TabData>[
      _TabData(l10n.navLists, Icons.checklist_rounded, Icons.list_alt,
          l10n.listsEmpty),
      _TabData(l10n.navCatalog, Icons.inventory_2_rounded, Icons.inventory_2_outlined,
          l10n.catalogEmpty),
      _TabData(l10n.navExpenses, Icons.bar_chart_rounded, Icons.bar_chart_outlined,
          l10n.expensesEmpty),
      _TabData(l10n.navSettings, Icons.settings_rounded, Icons.settings_outlined,
          ''),
    ];

    final current = tabs[_index];

    return Scaffold(
      appBar: AppBar(
        title: Text(current.label),
        actions: [
          // Quick language toggle (also lives in Settings).
          IconButton(
            tooltip: l10n.settingsLanguage,
            icon: const Icon(Icons.translate),
            onPressed: () => context.read<SettingsCubit>().toggleLanguage(),
          ),
        ],
      ),
      body: switch (_index) {
        0 => const ListsScreen(),
        1 => const CatalogScreen(),
        2 => const ExpensesScreen(),
        3 => const SettingsScreen(),
        _ => EmptyState(icon: current.filledIcon, message: current.emptyMessage),
      },
      floatingActionButton: switch (_index) {
        0 => FloatingActionButton(
            onPressed: () => ListsScreen.promptCreateList(context),
            child: const Icon(Icons.add),
          ),
        1 => FloatingActionButton(
            onPressed: () => CatalogScreen.openForm(context),
            child: const Icon(Icons.add),
          ),
        _ => null,
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final t in tabs)
            NavigationDestination(
              icon: Icon(t.outlinedIcon),
              selectedIcon: Icon(t.filledIcon),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _TabData {
  const _TabData(this.label, this.filledIcon, this.outlinedIcon, this.emptyMessage);
  final String label;
  final IconData filledIcon;
  final IconData outlinedIcon;
  final String emptyMessage;
}
