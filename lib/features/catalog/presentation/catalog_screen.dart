import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/entities/product.dart';
import 'cubit/catalog_cubit.dart';
import 'cubit/catalog_state.dart';
import 'product_form_page.dart';

/// Lists catalog products (the body shown under the Products tab) with a search
/// field. The parent [CatalogCubit] must be provided above this widget.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  /// Opens the add/edit product form, carrying the ambient [CatalogCubit].
  static void openForm(BuildContext context, [Product? product]) {
    final cubit = context.read<CatalogCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: ProductFormPage(existing: product),
        ),
      ),
    );
  }

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
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

  bool _matches(Product p, String q) {
    final lower = q.toLowerCase();
    return (p.nameEn ?? '').toLowerCase().contains(lower) ||
        (p.nameTa ?? '').contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state.status == CatalogStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        // Fully-empty catalog: no point showing a search box.
        if (state.products.isEmpty) {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            message: l10n.catalogEmpty,
            action: FilledButton.icon(
              onPressed: () => CatalogScreen.openForm(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.addProduct),
            ),
          );
        }

        final language = AppLanguage.fromCode(
          Localizations.localeOf(context).languageCode,
        );
        final visible = _query.isEmpty
            ? state.products
            : state.products.where((p) => _matches(p, _query)).toList();

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
                  hintText: l10n.searchCatalog,
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
                      message: l10n.catalogNoMatch,
                    )
                  : ListView.separated(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.sm),
                      itemCount: visible.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final product = visible[i];
                        final category = state.categoryOf(product.categoryId);
                        final categoryName = category == null
                            ? l10n.uncategorized
                            : resolveBilingual(
                                language: language,
                                nameTa: category.nameTa,
                                nameEn: category.nameEn,
                              );
                        return _ProductTile(
                          product: product,
                          categoryName: categoryName,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.categoryName});

  final Product product;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      title: BilingualText(nameTa: product.nameTa, nameEn: product.nameEn),
      subtitle: Text('$categoryName · ${product.unit}'),
      trailing: PriceText(product.basePricePaise),
      onTap: () {
        final cubit = context.read<CatalogCubit>();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: ProductFormPage(existing: product),
            ),
          ),
        );
      },
      onLongPress: () async {
        final cubit = context.read<CatalogCubit>();
        final confirmed = await showConfirmDialog(
          context,
          title: l10n.deleteProductConfirm,
          message: '',
          confirmLabel: l10n.commonDelete,
        );
        if (confirmed && product.id != null) {
          await cubit.deleteProduct(product.id!);
        }
      },
    );
  }
}
