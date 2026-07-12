import 'package:equatable/equatable.dart';

enum ListStatus { active, completed }

/// A grocery list / shopping trip.
class GroceryList extends Equatable {
  const GroceryList({
    this.id,
    required this.title,
    required this.createdAt,
    this.status = ListStatus.active,
  });

  final int? id;
  final String title;
  final DateTime createdAt;
  final ListStatus status;

  GroceryList copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    ListStatus? status,
  }) {
    return GroceryList(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, title, createdAt, status];
}
