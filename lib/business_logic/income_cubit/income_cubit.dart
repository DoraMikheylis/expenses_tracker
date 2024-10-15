import 'package:expenses_tracker/business_logic/income_cubit/income_state.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeCubit extends Cubit<IncomeState> {
  ExpenseRepository expenseRepository;

  IncomeCubit(this.expenseRepository)
      : super(const IncomeState(status: IncomeStatus.initial, incomes: []));

  Future<void> createIncome(Income income) async {
    emit(state.copyWith(status: IncomeStatus.loading));
    try {
      await expenseRepository.createIncome(income);
      emit(state.copyWith(status: IncomeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: IncomeStatus.failure));
    }
  }

  Future<void> getIncomes() async {
    emit(state.copyWith(status: IncomeStatus.loading));
    try {
      List<Income> incomes = await expenseRepository.getIncomes();
      emit(state.copyWith(status: IncomeStatus.success, incomes: incomes));
    } catch (e) {
      emit(state.copyWith(status: IncomeStatus.failure));
    }
  }
}
