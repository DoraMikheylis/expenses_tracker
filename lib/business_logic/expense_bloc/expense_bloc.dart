import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseRepository expenseRepository;
  ExpenseBloc(this.expenseRepository) : super(ExpenseInitial()) {
    on<CreateExpenseEvent>((event, emit) async {
      emit(CreateExpenseLoading());
      try {
        await expenseRepository.createExpense(event.expense);
        emit(CreateExpenseSuccess());
      } catch (e) {
        emit(CreateExpenseFailure());
      }
    });

    on<GetExpensesEvent>((event, emit) async {
      emit(GetExpensesLoading());
      try {
        List<Expense> expenses = await expenseRepository.getExpense();
        emit(GetExpensesSuccess(expenses: expenses));
      } catch (e) {
        emit(GetExpensesFailure());
      }
    });
  }
}