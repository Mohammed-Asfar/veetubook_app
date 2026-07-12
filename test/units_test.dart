// Tests unit quantity semantics: discrete units (piece/pack/dozen) are whole
// numbers stepping by 1; continuous units (kg/litre) allow fractions.

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/utils/units.dart';

void main() {
  test('discrete vs continuous classification', () {
    expect(Units.isDiscrete('piece'), isTrue);
    expect(Units.isDiscrete('pack'), isTrue);
    expect(Units.isDiscrete('dozen'), isTrue);
    expect(Units.isDiscrete('kg'), isFalse);
    expect(Units.isDiscrete('litre'), isFalse);
  });

  test('step is 1 for discrete, 0.25 for continuous', () {
    expect(Units.step('piece'), Decimal.one);
    expect(Units.step('kg'), Decimal.parse('0.25'));
  });

  test('minQty is 1 for discrete, 0 for continuous', () {
    expect(Units.minQty('pack'), Decimal.one);
    expect(Units.minQty('litre'), Decimal.zero);
  });

  test('normalize snaps discrete units to whole numbers, keeps fractions for kg',
      () {
    // You can't buy 1.25 packs -> rounds to a whole number.
    expect(Units.normalize('pack', Decimal.parse('1.25')), Decimal.fromInt(1));
    expect(Units.normalize('piece', Decimal.parse('2.6')), Decimal.fromInt(3));
    // Discrete never goes below 1.
    expect(Units.normalize('piece', Decimal.zero), Decimal.one);
    // kg keeps the fraction.
    expect(Units.normalize('kg', Decimal.parse('0.5')), Decimal.parse('0.5'));
    // continuous can be 0.
    expect(Units.normalize('kg', Decimal.zero), Decimal.zero);
  });
}
