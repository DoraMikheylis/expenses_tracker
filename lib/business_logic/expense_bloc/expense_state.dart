part of 'expense_bloc.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

final class ExpenseInitial extends ExpenseState {}

final class CreateExpenseFailure extends ExpenseState {}

final class CreateExpenseLoading extends ExpenseState {}

final class CreateExpenseSuccess extends ExpenseState {}

final class GetExpensesFailure extends ExpenseState {}

final class GetExpensesLoading extends ExpenseState {}

final class GetExpensesSuccess extends ExpenseState {
  final List<Expense> expenses;

  const GetExpensesSuccess({required this.expenses});

  @override
  List<Object> get props => [expenses];
}
