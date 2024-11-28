import 'dart:convert';
import 'dart:developer';
import 'package:expenses_tracker/business_logic/currency_cubit/currency_state.dart';
import 'package:expenses_tracker/data/data_providers/api/currency_model.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  ExpenseRepository expenseRepository;

  CurrencyCubit(this.expenseRepository)
      : super(const CurrencyState(status: CurrencyStatus.initial, rates: []));

  Future<void> getRates({
    required String currencies,
  }) async {
    emit(state.copyWith(status: CurrencyStatus.loading));
    try {
      final uri = Uri.parse(
          'https://api.tbcbank.ge/v1/exchange-rates/nbg?currency=$currencies&date=${DateFormat('yyyy-MM-dd').format(DateTime.now())}');

      final response = await http.get(
        uri,
        headers: {
          'apikey': 'nv9NvKXO95D0V1OFAA7SWFmTPPICPI8c',
        },
      );
      log('Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<CurrencyModel> rates =
            data.map((item) => CurrencyModel.fromJson(item)).toList();

        emit(state.copyWith(
          status: CurrencyStatus.success,
          rates: rates,
        ));
      } else {
        log('Error: ${response.statusCode} - ${response.reasonPhrase}');
        emit(state.copyWith(status: CurrencyStatus.failure));
      }
    } catch (e) {
      log('Error fetching rates: $e');
      emit(state.copyWith(status: CurrencyStatus.failure));
    }
  }
}
