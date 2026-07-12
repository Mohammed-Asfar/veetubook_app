import 'package:decimal/decimal.dart';

/// Unit semantics for quantities.
///
/// Some units are **discrete** — you buy whole counts of them (a piece, a pack,
/// a dozen). You can't buy 1.25 packs, so their quantity must be a whole number
/// and their stepper moves by 1. Others (kg, litre) are **continuous** — loose
/// quantities like 0.5 kg or 250 g are normal.
abstract final class Units {
  /// All selectable units, in display order.
  static const all = <String>[
    'kg', 'g', 'litre', 'ml', // continuous (weight / volume)
    'piece', 'pack', 'dozen', 'bunch', 'unit', // discrete (counts)
  ];

  static const _discrete = <String>{
    'piece', 'pack', 'dozen', 'bunch', 'unit',
  };

  /// True for count-based units where fractions make no sense.
  static bool isDiscrete(String unit) => _discrete.contains(unit);

  /// The ± stepper increment for a unit: 1 for discrete, 0.25 for continuous.
  static Decimal step(String unit) =>
      isDiscrete(unit) ? Decimal.one : Decimal.parse('0.25');

  /// The minimum quantity for a unit: 1 for discrete (you buy at least one),
  /// 0 for continuous.
  static Decimal minQty(String unit) =>
      isDiscrete(unit) ? Decimal.one : Decimal.zero;

  /// Snap a quantity to something valid for the unit: whole numbers for discrete
  /// units, unchanged for continuous ones. Never below the unit's minimum.
  static Decimal normalize(String unit, Decimal qty) {
    var q = qty;
    if (isDiscrete(unit)) {
      q = Decimal.fromInt(q.round().toBigInt().toInt());
    }
    final min = minQty(unit);
    return q < min ? min : q;
  }
}
