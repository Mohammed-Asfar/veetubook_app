import 'package:equatable/equatable.dart';

/// A completed shopping trip's expense record.
///
/// [date] is stored in UTC; monthly reports bucket by the device's local month.
/// [totalPaise] is the snapshot of the bought-items total at finish time.
class Expense extends Equatable {
  const Expense({
    this.id,
    required this.listId,
    required this.date,
    required this.totalPaise,
    this.listTitle,
  });

  final int? id;
  final int listId;
  final DateTime date;
  final int totalPaise;

  /// Denormalized for display convenience (joined from the list). Nullable
  /// because a raw expense row doesn't carry it.
  final String? listTitle;

  Expense copyWith({String? listTitle}) => Expense(
        id: id,
        listId: listId,
        date: date,
        totalPaise: totalPaise,
        listTitle: listTitle ?? this.listTitle,
      );

  @override
  List<Object?> get props => [id, listId, date, totalPaise, listTitle];
}
