part of 'expense_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class CreateExpenseEvent extends ExpenseEvent {
  final Expense expense;
  const CreateExpenseEvent({required this.expense});

  @override
  List<Object> get props => [expense];
}

class GetExpensesEvent extends ExpenseEvent {}
