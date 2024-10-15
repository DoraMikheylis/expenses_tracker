part of 'expense_bloc.dart';

sealed class ExpenseState extends Equatable {
  final List<Expense> expenses;

  const ExpenseState({this.expenses = const []});

  @override
  List<Object> get props => [expenses];
}

final class ExpenseInitial extends ExpenseState {}

final class CreateExpenseFailure extends ExpenseState {}

final class CreateExpenseLoading extends ExpenseState {}

final class CreateExpenseSuccess extends ExpenseState {}

final class GetExpensesFailure extends ExpenseState {}

final class GetExpensesLoading extends ExpenseState {}

final class GetExpensesSuccess extends ExpenseState {
  const GetExpensesSuccess({required List<Expense> expenses})
      : super(expenses: expenses);
}

final class DeleteExpenseSuccess extends ExpenseState {}

final class DeleteExpenseFailure extends ExpenseState {}

final class DeleteExpenseLoading extends ExpenseState {}
