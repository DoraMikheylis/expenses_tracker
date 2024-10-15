import 'package:equatable/equatable.dart';
import 'package:expenses_tracker/data/models/income.dart';

enum IncomeStatus { initial, loading, success, failure }

class IncomeState extends Equatable {
  final List<Income> incomes;
  final IncomeStatus status;

  const IncomeState({required this.status, required this.incomes});

  @override
  List<Object> get props => [status, incomes];

  IncomeState copyWith({
    IncomeStatus? status,
    List<Income>? incomes,
  }) {
    return IncomeState(
        status: status ?? this.status, incomes: incomes ?? this.incomes);
  }
}
