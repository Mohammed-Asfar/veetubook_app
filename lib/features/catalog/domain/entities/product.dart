import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/money.dart';

/// A reusable product "price template" (bilingual).
///
/// Price is stored as integer paise for [baseQty] of [unit] (e.g. ₹50 / 1 kg).
/// At least one of [nameTa]/[nameEn] must be non-empty (enforced on save).
class Product extends Equatable {
  const Product({
    this.id,
    this.nameTa,
    this.nameEn,
    this.categoryId,
    this.unit = 'unit',
    required this.baseQty,
    this.basePricePaise = 0,
    this.isDeleted = false,
  });

  final int? id;
  final String? nameTa;
  final String? nameEn;
  final int? categoryId;
  final String unit;
  final Decimal baseQty;
  final int basePricePaise;
  final bool isDeleted;

  /// Snapshot unit price in paise (basePrice / baseQty), rounded to paise.
  int get unitPricePaise => Money.lineTotalPaise(
        basePricePaise: basePricePaise,
        baseQty: baseQty,
        qty: Decimal.one,
      );

  /// True when neither name is provided — invalid for saving.
  bool get hasNoName =>
      (nameTa ?? '').trim().isEmpty && (nameEn ?? '').trim().isEmpty;

  Product copyWith({
    int? id,
    String? nameTa,
    String? nameEn,
    int? categoryId,
    String? unit,
    Decimal? baseQty,
    int? basePricePaise,
    bool? isDeleted,
  }) {
    return Product(
      id: id ?? this.id,
      nameTa: nameTa ?? this.nameTa,
      nameEn: nameEn ?? this.nameEn,
      categoryId: categoryId ?? this.categoryId,
      unit: unit ?? this.unit,
      baseQty: baseQty ?? this.baseQty,
      basePricePaise: basePricePaise ?? this.basePricePaise,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props =>
      [id, nameTa, nameEn, categoryId, unit, baseQty, basePricePaise, isDeleted];
}
