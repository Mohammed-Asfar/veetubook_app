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

/// Lists catalog products (the body shown under the Products tab). The parent
/// [CatalogCubit] must be provided above this widget.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state.status == CatalogStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.products.isEmpty) {
          return EmptyState(
            icon: Icons.inventory_2_outlined,
            message: l10n.catalogEmpty,
            action: FilledButton.icon(
              onPressed: () => openForm(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.addProduct),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: state.products.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final product = state.products[i];
            final category = state.categoryOf(product.categoryId);
            final language = AppLanguage.fromCode(
              Localizations.localeOf(context).languageCode,
            );
            final categoryName = category == null
                ? l10n.uncategorized
                : resolveBilingual(
                    language: language,
                    nameTa: category.nameTa,
                    nameEn: category.nameEn,
                  );
            return _ProductTile(product: product, categoryName: categoryName);
          },
        );
      },
    );
  }

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
