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

class GetExpensesEvent extends ExpenseEvent {
  const GetExpensesEvent({
    this.limit,
  });

  final int? limit;
}

class GetExpensesByCategoryEvent extends ExpenseEvent {
  const GetExpensesByCategoryEvent({
    required this.categoryId,
    this.limit,
  });

  final String categoryId;

  final int? limit;
}

class GetExpensesGroupedByCategoryEvent extends ExpenseEvent {
  const GetExpensesGroupedByCategoryEvent();
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String expenseId;
  const DeleteExpenseEvent({required this.expenseId});
}
