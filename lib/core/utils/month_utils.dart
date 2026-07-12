import 'package:intl/intl.dart';

/// A calendar month bucket (year + month), timezone-safe.
///
/// PRD rule: timestamps are stored in UTC but reports are bucketed by the
/// device's **local** month. Construct from a local [DateTime].
class YearMonth implements Comparable<YearMonth> {
  const YearMonth(this.year, this.month);

  final int year;
  final int month; // 1..12

  /// Bucket a stored UTC timestamp into its local month.
  factory YearMonth.fromDate(DateTime date) {
    final local = date.toLocal();
    return YearMonth(local.year, local.month);
  }

  /// The month immediately before this one (handles January -> prev December).
  YearMonth get previous =>
      month == 1 ? YearMonth(year - 1, 12) : YearMonth(year, month - 1);

  /// Inclusive local-time start of this month.
  DateTime get start => DateTime(year, month, 1);

  /// Exclusive local-time start of the next month (upper bound for queries).
  DateTime get endExclusive =>
      month == 12 ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);

  /// Number of days in this month (handles February / leap years).
  int get daysInMonth => endExclusive.subtract(const Duration(days: 1)).day;

  String label({String locale = 'en_IN'}) =>
      DateFormat.yMMM(locale).format(start);

  @override
  int compareTo(YearMonth other) =>
      year != other.year ? year.compareTo(other.year) : month.compareTo(other.month);

  @override
  bool operator ==(Object other) =>
      other is YearMonth && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => '$year-${month.toString().padLeft(2, '0')}';
}

/// Result of a month-over-month comparison. Guards against divide-by-zero
/// when there is no prior data (PRD edge case).
class MonthComparison {
  const MonthComparison({
    required this.current,
    required this.previous,
    required this.currentTotalPaise,
    required this.previousTotalPaise,
  });

  final YearMonth current;
  final YearMonth previous;
  final int currentTotalPaise;
  final int previousTotalPaise;

  bool get hasPrior => previousTotalPaise > 0;

  /// Percentage change vs previous month, or null when there's no prior data.
  double? get percentChange {
    if (!hasPrior) return null;
    return (currentTotalPaise - previousTotalPaise) / previousTotalPaise * 100;
  }

  bool get isUp => percentChange != null && percentChange! > 0;
  bool get isDown => percentChange != null && percentChange! < 0;
}
