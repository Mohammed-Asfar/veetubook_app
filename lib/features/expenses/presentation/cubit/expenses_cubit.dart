import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/monthly_summary.dart';
import '../../domain/expenses_repository.dart';

class ExpensesState extends Equatable {
  const ExpensesState({
    this.loading = true,
    this.expenses = const [],
    this.months = const [],
  });

  final bool loading;
  final List<Expense> expenses;
  final List<MonthlySummary> months;

  ExpensesState copyWith({
    bool? loading,
    List<Expense>? expenses,
    List<MonthlySummary>? months,
  }) {
    return ExpensesState(
      loading: loading ?? this.loading,
      expenses: expenses ?? this.expenses,
      months: months ?? this.months,
    );
  }

  @override
  List<Object?> get props => [loading, expenses, months];
}

/// Watches trip history and monthly summaries for the Expenses tab.
class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit(this._repo) : super(const ExpensesState()) {
    _expensesSub = _repo.watchExpenses().listen(
          (expenses) =>
              emit(state.copyWith(loading: false, expenses: expenses)),
        );
    _monthsSub = _repo.watchMonthlySummaries().listen(
          (months) => emit(state.copyWith(months: months)),
        );
  }

  final ExpensesRepository _repo;
  StreamSubscription<List<Expense>>? _expensesSub;
  StreamSubscription<List<MonthlySummary>>? _monthsSub;

  @override
  Future<void> close() {
    _expensesSub?.cancel();
    _monthsSub?.cancel();
    return super.close();
  }
}
