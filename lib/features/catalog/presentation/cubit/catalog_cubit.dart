import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/catalog_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import 'catalog_state.dart';

/// Drives the catalog screen by combining the reactive product & category
/// streams from the repository. Drift emits new values on any DB change, so the
/// UI stays in sync automatically.
class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repo) : super(const CatalogState()) {
    _subscribe();
  }

  final CatalogRepository _repo;
  StreamSubscription<List<Product>>? _productsSub;
  StreamSubscription<List<Category>>? _categoriesSub;

  void _subscribe() {
    _categoriesSub = _repo.watchCategories().listen(
          (categories) => emit(state.copyWith(categories: categories)),
          onError: (Object e) =>
              emit(state.copyWith(status: CatalogStatus.error, error: '$e')),
        );
    _productsSub = _repo.watchProducts().listen(
          (products) => emit(
            state.copyWith(status: CatalogStatus.ready, products: products),
          ),
          onError: (Object e) =>
              emit(state.copyWith(status: CatalogStatus.error, error: '$e')),
        );
  }

  Future<void> saveProduct(Product product) => _repo.saveProduct(product);

  Future<void> deleteProduct(int id) => _repo.deleteProduct(id);

  @override
  Future<void> close() {
    _productsSub?.cancel();
    _categoriesSub?.cancel();
    return super.close();
  }
}
