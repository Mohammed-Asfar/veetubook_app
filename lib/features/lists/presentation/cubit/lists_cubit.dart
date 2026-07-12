import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/grocery_list.dart';
import '../../domain/lists_repository.dart';

class ListsState extends Equatable {
  const ListsState({this.loading = true, this.lists = const []});

  final bool loading;
  final List<GroceryList> lists;

  ListsState copyWith({bool? loading, List<GroceryList>? lists}) =>
      ListsState(loading: loading ?? this.loading, lists: lists ?? this.lists);

  @override
  List<Object?> get props => [loading, lists];
}

/// Watches all grocery lists and exposes create/rename/delete operations.
class ListsCubit extends Cubit<ListsState> {
  ListsCubit(this._repo) : super(const ListsState()) {
    _sub = _repo.watchLists().listen(
          (lists) => emit(ListsState(loading: false, lists: lists)),
        );
  }

  final ListsRepository _repo;
  StreamSubscription<List<GroceryList>>? _sub;

  Future<int> createList(String title) => _repo.createList(title);
  Future<void> renameList(int id, String title) =>
      _repo.renameList(id, title);
  Future<void> deleteList(int id) => _repo.deleteList(id);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
