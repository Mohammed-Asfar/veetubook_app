import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/entities/product.dart';
import 'cubit/catalog_cubit.dart';
import 'cubit/catalog_state.dart';

/// Add / edit a catalog product. Shows a live auto-calc preview of the price
/// for a chosen quantity (F1a) so the user can sanity-check the unit price.
class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key, this.existing});

  final Product? existing;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEn;
  late final TextEditingController _nameTa;
  late final TextEditingController _price; // rupees, as entered
  late final TextEditingController _baseQty;
  late String _unit;
  int? _categoryId;

  // Preview quantity for the auto-calc demonstration.
  Decimal _previewQty = Decimal.fromInt(3);

  static const _units = ['kg', 'g', 'litre', 'ml', 'piece', 'bunch', 'unit'];

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    _nameEn = TextEditingController(text: p?.nameEn ?? '');
    _nameTa = TextEditingController(text: p?.nameTa ?? '');
    _price = TextEditingController(
      text: p == null ? '' : Money.paiseToRupees(p.basePricePaise).toString(),
    );
    _baseQty = TextEditingController(text: p?.baseQty.toString() ?? '1');
    _unit = p?.unit ?? 'kg';
    _categoryId = p?.categoryId;
  }

  @override
  void dispose() {
    _nameEn.dispose();
    _nameTa.dispose();
    _price.dispose();
    _baseQty.dispose();
    super.dispose();
  }

  int get _basePricePaise {
    final rupees = Decimal.tryParse(_price.text.trim()) ?? Decimal.zero;
    return Money.rupeesToPaise(rupees);
  }

  Decimal get _baseQtyValue {
    final q = Decimal.tryParse(_baseQty.text.trim()) ?? Decimal.one;
    return q <= Decimal.zero ? Decimal.one : q;
  }

  int get _previewPaise => Money.lineTotalPaise(
        basePricePaise: _basePricePaise,
        baseQty: _baseQtyValue,
        qty: _previewQty,
      );

  bool get _hasName =>
      _nameEn.text.trim().isNotEmpty || _nameTa.text.trim().isNotEmpty;

  Future<void> _save() async {
    if (!_hasName) {
      // Trigger validator display.
      _formKey.currentState?.validate();
      return;
    }
    final product = (widget.existing ?? _emptyProduct()).copyWith(
      nameEn: _nameEn.text.trim(),
      nameTa: _nameTa.text.trim(),
      unit: _unit,
      baseQty: _baseQtyValue,
      basePricePaise: _basePricePaise,
      categoryId: _categoryId,
    );
    await context.read<CatalogCubit>().saveProduct(product);
    if (mounted) Navigator.of(context).pop();
  }

  Product _emptyProduct() => Product(baseQty: Decimal.one);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final language =
        AppLanguage.fromCode(Localizations.localeOf(context).languageCode);
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.editProduct : l10n.addProduct),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextFormField(
              controller: _nameEn,
              decoration: InputDecoration(labelText: l10n.nameEnglish),
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              validator: (_) => _hasName ? null : l10n.nameRequired,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _nameTa,
              decoration: InputDecoration(labelText: l10n.nameTamil),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _price,
                    decoration: InputDecoration(
                      labelText: l10n.basePrice,
                      prefixText: '₹ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _baseQty,
                    decoration: InputDecoration(labelText: l10n.quantity),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              initialValue: _unit,
              decoration: InputDecoration(labelText: l10n.unit),
              items: [
                for (final u in _units)
                  DropdownMenuItem(value: u, child: Text(u)),
              ],
              onChanged: (u) => setState(() => _unit = u ?? _unit),
            ),
            const SizedBox(height: AppSpacing.lg),
            _CategoryDropdown(
              value: _categoryId,
              language: language,
              onChanged: (id) => setState(() => _categoryId = id),
            ),
            const SizedBox(height: AppSpacing.xl),
            _AutoCalcPreview(
              unit: _unit,
              qty: _previewQty,
              pricePaise: _previewPaise,
              onQtyChanged: (q) => setState(() => _previewQty = q),
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: _save,
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.value,
    required this.language,
    required this.onChanged,
  });

  final int? value;
  final AppLanguage language;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<CatalogCubit, CatalogState>(
      buildWhen: (a, b) => a.categories != b.categories,
      builder: (context, state) {
        return DropdownButtonFormField<int?>(
          initialValue: value,
          decoration: InputDecoration(labelText: l10n.category),
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(l10n.uncategorized),
            ),
            for (final c in state.categories)
              DropdownMenuItem<int?>(
                value: c.id,
                child: Text(
                  resolveBilingual(
                    language: language,
                    nameTa: c.nameTa,
                    nameEn: c.nameEn,
                  ),
                ),
              ),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}

/// Shows the auto-calculated price for a preview quantity (F1a).
class _AutoCalcPreview extends StatelessWidget {
  const _AutoCalcPreview({
    required this.unit,
    required this.qty,
    required this.pricePaise,
    required this.onQtyChanged,
  });

  final String unit;
  final Decimal qty;
  final int pricePaise;
  final ValueChanged<Decimal> onQtyChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final integerOnly = unit == 'piece';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.priceForQty(_fmtQty(qty), unit),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            QuantityStepper(
              value: qty,
              integerOnly: integerOnly,
              min: integerOnly ? Decimal.one : Decimal.zero,
              onChanged: onQtyChanged,
            ),
            const SizedBox(width: AppSpacing.md),
            PriceText(pricePaise),
          ],
        ),
      ),
    );
  }

  static String _fmtQty(Decimal d) {
    final s = d.toString();
    if (!s.contains('.')) return s;
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
