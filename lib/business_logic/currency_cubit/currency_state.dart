import 'package:equatable/equatable.dart';
import 'package:expenses_tracker/data/data_providers/api/currency_model.dart';

enum CurrencyStatus { initial, loading, success, failure }

class CurrencyState extends Equatable {
  final List<CurrencyModel> rates;
  final CurrencyStatus status;

  const CurrencyState({required this.rates, required this.status});

  @override
  List<Object?> get props => [rates, status];

  CurrencyState copyWith({
    CurrencyStatus? status,
    List<CurrencyModel>? rates,
  }) {
    return CurrencyState(
      status: status ?? this.status,
      rates: rates ?? this.rates,
    );
  }
}
