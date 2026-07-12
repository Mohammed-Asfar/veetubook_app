import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

enum CatalogStatus { loading, ready, error }

class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.loading,
    this.products = const [],
    this.categories = const [],
    this.error,
  });

  final CatalogStatus status;
  final List<Product> products;
  final List<Category> categories;
  final String? error;

  /// Category lookup by id for showing a product's category name.
  Category? categoryOf(int? id) {
    if (id == null) return null;
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  CatalogState copyWith({
    CatalogStatus? status,
    List<Product>? products,
    List<Category>? categories,
    String? error,
  }) {
    return CatalogState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, products, categories, error];
}
