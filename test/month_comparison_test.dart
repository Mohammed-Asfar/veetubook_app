// Unit tests for the month-over-month comparison logic and month boundaries
// (PRD edge cases: no-prior-data divide-by-zero guard, January -> prev December).

import 'package:flutter_test/flutter_test.dart';
import 'package:veetubook/core/utils/month_utils.dart';

void main() {
  group('YearMonth', () {
    test('previous handles the January -> December year rollover', () {
      expect(const YearMonth(2026, 1).previous, const YearMonth(2025, 12));
      expect(const YearMonth(2026, 7).previous, const YearMonth(2026, 6));
    });

    test('endExclusive rolls over in December', () {
      expect(const YearMonth(2026, 12).endExclusive, DateTime(2027, 1, 1));
      expect(const YearMonth(2026, 7).endExclusive, DateTime(2026, 8, 1));
    });

    test('fromDate buckets by local month', () {
      final ym = YearMonth.fromDate(DateTime(2026, 7, 11, 23, 30));
      expect(ym, const YearMonth(2026, 7));
    });
  });

  group('MonthComparison', () {
    test('no prior data -> percentChange is null, not a divide-by-zero', () {
      const c = MonthComparison(
        current: YearMonth(2026, 7),
        previous: YearMonth(2026, 6),
        currentTotalPaise: 15000,
        previousTotalPaise: 0,
      );
      expect(c.hasPrior, isFalse);
      expect(c.percentChange, isNull);
      expect(c.isUp, isFalse);
      expect(c.isDown, isFalse);
    });

    test('spend up month-over-month', () {
      const c = MonthComparison(
        current: YearMonth(2026, 7),
        previous: YearMonth(2026, 6),
        currentTotalPaise: 12000,
        previousTotalPaise: 10000,
      );
      expect(c.percentChange, 20.0);
      expect(c.isUp, isTrue);
      expect(c.isDown, isFalse);
    });

    test('spend down month-over-month', () {
      const c = MonthComparison(
        current: YearMonth(2026, 7),
        previous: YearMonth(2026, 6),
        currentTotalPaise: 8000,
        previousTotalPaise: 10000,
      );
      expect(c.percentChange, -20.0);
      expect(c.isDown, isTrue);
      expect(c.isUp, isFalse);
    });
  });
}
