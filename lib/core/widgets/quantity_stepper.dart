import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme_extension.dart';

/// Reusable quantity control used in catalog / list / shopping.
///
/// Supports fractional steps (e.g. 0.25 kg) or integer-only units (e.g. pieces)
/// via [integerOnly]. Never lets quantity go below [min].
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.step,
    this.integerOnly = false,
    this.min,
  });

  final Decimal value;
  final ValueChanged<Decimal> onChanged;
  final Decimal? step;
  final bool integerOnly;
  final Decimal? min;

  @override
  Widget build(BuildContext context) {
    final effectiveStep =
        step ?? (integerOnly ? Decimal.one : Decimal.parse('0.25'));
    final effectiveMin = min ?? Decimal.zero;
    final border = context.appColors.border;

    void bump(Decimal delta) {
      var next = value + delta;
      if (next < effectiveMin) next = effectiveMin;
      onChanged(next);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: value <= effectiveMin ? null : () => bump(-effectiveStep),
            visualDensity: VisualDensity.compact,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              _fmt(value),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => bump(effectiveStep),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  static String _fmt(Decimal d) {
    // Trim trailing zeros: 1.00 -> 1, 0.50 -> 0.5
    final s = d.toString();
    if (!s.contains('.')) return s;
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
