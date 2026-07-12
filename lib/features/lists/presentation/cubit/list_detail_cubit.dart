import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/money.dart';
import '../../../catalog/domain/catalog_repository.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../expenses/domain/expenses_repository.dart';
import '../../domain/entities/list_item.dart';
import '../../domain/lists_repository.dart';

class ListDetailState extends Equatable {
  const ListDetailState({this.loading = true, this.items = const []});

  final bool loading;
  final List<ListItem> items;

  /// Running total of BOUGHT items (what the trip actually cost so far).
  int get boughtTotalPaise =>
      items.where((i) => i.isBought).fold(0, (s, i) => s + i.linePricePaise);

  /// Total of all items on the list (planned spend).
  int get plannedTotalPaise =>
      items.fold(0, (s, i) => s + i.linePricePaise);

  ListDetailState copyWith({bool? loading, List<ListItem>? items}) =>
      ListDetailState(
        loading: loading ?? this.loading,
        items: items ?? this.items,
      );

  @override
  List<Object?> get props => [loading, items];
}

/// Watches one list's items and exposes item operations, including adding from
/// a catalog [Product] (snapshotting price/name) or an ad-hoc item.
class ListDetailCubit extends Cubit<ListDetailState> {
  ListDetailCubit(this._repo, this._expenses, this._catalog, this.listId)
      : super(const ListDetailState()) {
    _sub = _repo.watchItems(listId).listen(
          (items) => emit(ListDetailState(loading: false, items: items)),
        );
  }

  final ListsRepository _repo;
  final ExpensesRepository _expenses;
  final CatalogRepository _catalog;
  final int listId;
  StreamSubscription<List<ListItem>>? _sub;

  /// Keep this list's expense record in sync with its bought-items total.
  /// Called automatically after any change that can affect what's been bought,
  /// so the list becomes/updates an expense without a manual "finish" step.
  Future<void> _syncExpense() => _expenses.syncExpenseForList(listId);

  /// Add a catalog product to this list, snapshotting its unit price & name.
  Future<void> addFromProduct(Product product, Decimal qty) {
    final item = ListItem(
      listId: listId,
      productId: product.id,
      nameTa: product.nameTa,
      nameEn: product.nameEn,
      unit: product.unit,
      qty: qty,
      unitPricePaise: product.unitPricePaise,
    );
    return _repo.addItem(item);
  }

  /// Add a one-off item not backed by a catalog product.
  Future<void> addAdHoc({
    String? nameTa,
    String? nameEn,
    required String unit,
    required Decimal qty,
    required int unitPricePaise,
  }) {
    final item = ListItem(
      listId: listId,
      nameTa: nameTa,
      nameEn: nameEn,
      unit: unit,
      qty: qty,
      unitPricePaise: unitPricePaise,
    );
    return _repo.addItem(item);
  }

  /// Change quantity — re-runs auto-calc unless the price was overridden.
  Future<void> changeQty(ListItem item, Decimal qty) async {
    await _repo.updateItem(item.copyWith(qty: qty));
    await _syncExpense();
  }

  /// Manually override the line price (turns off auto-calc for this item).
  Future<void> overridePrice(ListItem item, int linePricePaise) async {
    await _repo.updateItem(
      item.copyWith(linePricePaise: linePricePaise, isPriceOverridden: true),
    );
    await _syncExpense();
  }

  Future<void> setBought(ListItem item, bool bought) async {
    await _repo.setBought(item.id!, bought);
    await _syncExpense();
  }

  /// Full item edit from the list itself (no trip to the catalog): name,
  /// category, unit, price and quantity. The changes update this list item AND
  /// are written back to the source catalog product so they're the default next
  /// time (per the user's choice). [categoryId] is only applied to the product.
  Future<void> editItem(
    ListItem item, {
    required String? nameEn,
    required String? nameTa,
    required String unit,
    required int unitPricePaise,
    required Decimal qty,
    int? categoryId,
  }) async {
    final linePaise = Money.lineTotalPaise(
      basePricePaise: unitPricePaise,
      baseQty: Decimal.one,
      qty: qty,
    );
    await _repo.updateItem(item.copyWith(
      nameEn: nameEn,
      nameTa: nameTa,
      unit: unit,
      unitPricePaise: unitPricePaise,
      qty: qty,
      linePricePaise: linePaise,
      isPriceOverridden: false,
    ));

    // Persist name/category/unit/price back to the catalog product.
    if (item.productId != null) {
      final product = await _catalog.getProduct(item.productId!);
      if (product != null) {
        await _catalog.saveProduct(product.copyWith(
          nameEn: nameEn,
          nameTa: nameTa,
          unit: unit,
          categoryId: categoryId,
          basePricePaise: unitPricePaise,
          baseQty: Decimal.one,
        ));
      }
    }

    await _syncExpense();
  }

  /// The catalog product backing an item (for pre-filling the editor's
  /// category), or null for ad-hoc items.
  Future<Product?> productFor(ListItem item) =>
      item.productId == null ? Future.value(null) : _catalog.getProduct(item.productId!);

  Future<void> removeItem(ListItem item) async {
    await _repo.removeItem(item.id!);
    // A removed item may have been bought, so refresh the expense total.
    await _syncExpense();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
