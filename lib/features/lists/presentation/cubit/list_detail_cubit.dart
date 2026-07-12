import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  ListDetailCubit(this._repo, this._expenses, this.listId)
      : super(const ListDetailState()) {
    _sub = _repo.watchItems(listId).listen(
          (items) => emit(ListDetailState(loading: false, items: items)),
        );
  }

  final ListsRepository _repo;
  final ExpensesRepository _expenses;
  final int listId;
  StreamSubscription<List<ListItem>>? _sub;

  /// Finish this trip: atomically saves the bought-items total as an expense
  /// and marks the list completed (delegates to the transaction in the repo).
  Future<void> finishTrip() => _expenses.finishTrip(listId);

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
  Future<void> changeQty(ListItem item, Decimal qty) =>
      _repo.updateItem(item.copyWith(qty: qty));

  /// Manually override the line price (turns off auto-calc for this item).
  Future<void> overridePrice(ListItem item, int linePricePaise) => _repo
      .updateItem(item.copyWith(linePricePaise: linePricePaise, isPriceOverridden: true));

  Future<void> setBought(ListItem item, bool bought) =>
      _repo.setBought(item.id!, bought);

  Future<void> removeItem(ListItem item) => _repo.removeItem(item.id!);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
