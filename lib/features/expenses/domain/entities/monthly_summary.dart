import 'package:equatable/equatable.dart';

import '../../../../core/utils/month_utils.dart';

/// Total spend for one local calendar month (used by M4 analytics, produced by
/// the expenses repository).
class MonthlySummary extends Equatable {
  const MonthlySummary({
    required this.month,
    required this.totalPaise,
    required this.tripCount,
  });

  final YearMonth month;
  final int totalPaise;
  final int tripCount;

  @override
  List<Object?> get props => [month, totalPaise, tripCount];
}
