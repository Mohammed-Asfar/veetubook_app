import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/money.dart';

/// An item on a grocery list.
///
/// Price and name are SNAPSHOTTED here (not read live from the product) so that
/// editing/deleting the source product never rewrites this list or its expense
/// record (PRD). `linePricePaise` is auto = unitPrice × qty unless the user
/// has overridden it (`isPriceOverridden`).
class ListItem extends Equatable {
  const ListItem({
    this.id,
    required this.listId,
    this.productId,
    this.nameTa,
    this.nameEn,
    this.unit = 'unit',
    required this.qty,
    this.unitPricePaise = 0,
    this.linePricePaise = 0,
    this.isPriceOverridden = false,
    this.isBought = false,
  });

  final int? id;
  final int listId;
  final int? productId;
  final String? nameTa;
  final String? nameEn;
  final String unit;
  final Decimal qty;
  final int unitPricePaise;
  final int linePricePaise;
  final bool isPriceOverridden;
  final bool isBought;

  /// Recompute the line price from unit price × qty (unless overridden).
  int computedLinePaise() {
    if (isPriceOverridden) return linePricePaise;
    return Money.lineTotalPaise(
      basePricePaise: unitPricePaise,
      baseQty: Decimal.one,
      qty: qty,
    );
  }

  ListItem copyWith({
    int? id,
    int? listId,
    int? productId,
    String? nameTa,
    String? nameEn,
    String? unit,
    Decimal? qty,
    int? unitPricePaise,
    int? linePricePaise,
    bool? isPriceOverridden,
    bool? isBought,
  }) {
    return ListItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      productId: productId ?? this.productId,
      nameTa: nameTa ?? this.nameTa,
      nameEn: nameEn ?? this.nameEn,
      unit: unit ?? this.unit,
      qty: qty ?? this.qty,
      unitPricePaise: unitPricePaise ?? this.unitPricePaise,
      linePricePaise: linePricePaise ?? this.linePricePaise,
      isPriceOverridden: isPriceOverridden ?? this.isPriceOverridden,
      isBought: isBought ?? this.isBought,
    );
  }

  @override
  List<Object?> get props => [
        id,
        listId,
        productId,
        nameTa,
        nameEn,
        unit,
        qty,
        unitPricePaise,
        linePricePaise,
        isPriceOverridden,
        isBought,
      ];
}
