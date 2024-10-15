import 'package:equatable/equatable.dart';
import 'package:expenses_tracker/data/models/models.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  final List<Map<Category, List<Expense>>> listMonthlyExpenses;
  final StatsStatus status;
  final int pageIndex;
  final Category? selectedCategory;

  const StatsState(
      {required this.listMonthlyExpenses,
      required this.status,
      required this.pageIndex,
      this.selectedCategory});

  @override
  List<Object?> get props =>
      [status, listMonthlyExpenses, pageIndex, selectedCategory];

  StatsState copyWith(
      {StatsStatus? status,
      List<Map<Category, List<Expense>>>? listMonthlyExpenses,
      int? pageIndex,
      Category? selectedCategory}) {
    return StatsState(
      status: status ?? this.status,
      listMonthlyExpenses: listMonthlyExpenses ?? this.listMonthlyExpenses,
      pageIndex: pageIndex ?? this.pageIndex,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
