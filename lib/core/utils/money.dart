import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

/// Money handling for veetubook.
///
/// Rule (see PRD): money is stored as **integer paise** in SQLite and computed
/// with [Decimal] — never raw `double` — to avoid float rounding errors.
/// Format to ₹ only at display time using [format].
abstract final class Money {
  static final Decimal _hundred = Decimal.fromInt(100);

  /// Round-half-up to 2 dp, returned as integer paise.
  static int rupeesToPaise(Decimal rupees) {
    final paise = rupees * _hundred;
    return paise.round().toBigInt().toInt();
  }

  static Decimal paiseToRupees(int paise) =>
      (Decimal.fromInt(paise) / _hundred).toDecimal();

  /// Auto price calculation used across catalog/list/shopping.
  ///
  /// `linePaise = round( unitPricePaise * qty )`, where
  /// `unitPricePaise = basePricePaise / baseQty`.
  /// Returns integer paise, round-half-up.
  static int lineTotalPaise({
    required int basePricePaise,
    required Decimal baseQty,
    required Decimal qty,
  }) {
    if (baseQty == Decimal.zero) return 0;
    // Decimal / Decimal yields a Rational; multiply by qty's Rational view and
    // round to the nearest integer paise (round-half-up). Rational.round()
    // returns a BigInt directly.
    final unit = Decimal.fromInt(basePricePaise) / baseQty; // Rational
    final total = unit * qty.toRational();
    return total.round().toInt();
  }

  /// Formats integer paise as a currency string, e.g. 15000 -> "₹150.00".
  /// Uses Indian grouping (en_IN) by default: ₹1,00,000.00.
  static String format(int paise, {String locale = 'en_IN', String symbol = '₹'}) {
    final rupees = paiseToRupees(paise);
    final fmt = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );
    return fmt.format(rupees.toDouble());
  }
}
