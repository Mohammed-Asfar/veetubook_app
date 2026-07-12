import 'package:equatable/equatable.dart';

/// A product category (bilingual). `id == null` for a not-yet-persisted entity.
class Category extends Equatable {
  const Category({
    this.id,
    this.nameTa,
    this.nameEn,
  });

  final int? id;
  final String? nameTa;
  final String? nameEn;

  @override
  List<Object?> get props => [id, nameTa, nameEn];
}
