import 'package:expenses_tracker/business_logic/stats_cubit/stats_state.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsCubit extends Cubit<StatsState> {
  ExpenseRepository expenseRepository;

  StatsCubit(this.expenseRepository)
      : super(const StatsState(
            status: StatsStatus.initial,
            listMonthlyExpenses: [],
            pageIndex: 0));

  Future<void> getExpensesGroupedByCategory({DateTime? date}) async {
    try {
      Map<String, List<Expense>> expenses =
          await expenseRepository.getExpensesGroupedByCategory(date: date);
      emit(state.copyWith(
          status: StatsStatus.success,
          listMonthlyExpenses: [...state.listMonthlyExpenses, expenses]));
    } catch (e) {
      emit(state.copyWith(status: StatsStatus.failure));
    }
  }

  Future<void> getExpensesGroupedByCategoryByMonth(
      {required DateTime date}) async {
    emit(state.copyWith(status: StatsStatus.loading));
    try {
      List<Map<String, List<Expense>>> expenses = [];
      for (int i = 0; i < 3; i++) {
        expenses.add(await expenseRepository.getExpensesGroupedByCategory(
            date: subtractMonth(date: date, months: i)));
      }
      emit(state.copyWith(
          status: StatsStatus.success, listMonthlyExpenses: expenses));
    } catch (e) {
      emit(state.copyWith(status: StatsStatus.failure));
    }
  }

  void setPageIndex(int index) {
    emit(state.copyWith(pageIndex: index));
  }

  void setSelectedCategory(String categoryId) async {
    var category = await expenseRepository.getCategoryById(categoryId);
    emit(state.copyWith(selectedCategory: category));
  }

  DateTime subtractMonth({required DateTime date, required int months}) {
    int year = date.year;
    int month = date.month - months;

    year += (month - 1) ~/ 12;
    month = (month - 1) % 12 + 1;

    return DateTime(year, month, date.day);
  }
}
