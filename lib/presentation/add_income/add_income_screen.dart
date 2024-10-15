import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:expenses_tracker/data/models/income.dart';
import 'package:expenses_tracker/presentation/widgets/save_button.dart';
import 'package:expenses_tracker/business_logic/income_cubit/income_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../business_logic/income_cubit/income_cubit.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late Income income;
  final _formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    income = Income.createEmpty();
    income.incomeId = const Uuid().v1();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    incomeController.dispose();
    dateController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar:
              AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: MediaQuery.of(context).size.height * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Add Income',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        focusNode: _focusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the income amount';
                          }
                          return null;
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\,?\d*')),
                        ],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 26,
                        ),
                        controller: incomeController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.surfaceBright,
                            prefixIcon: Icon(
                              FontAwesomeIcons.lariSign,
                              size: 22,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    EasyDateTimeLine(
                      initialDate: income.date,
                      onDateChange: (DateTime newDate) {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          dateController.text =
                              DateFormat('dd/MM/yyyy').format(newDate);
                          income.date = newDate;
                        });
                      },
                      activeColor: const Color(0xffFFBF9B),
                      headerProps: const EasyHeaderProps(
                        dateFormatter: DateFormatter.monthOnly(),
                      ),
                      dayProps: EasyDayProps(
                        todayHighlightColor:
                            Theme.of(context).colorScheme.tertiary,
                        height: 50.0,
                        width: 50.0,
                        dayStructure: DayStructure.dayNumDayStr,
                        inactiveDayStyle: const DayStyle(
                          borderRadius: 30.0,
                          dayNumStyle: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        activeDayStyle: DayStyle(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(12.0)),
                          dayNumStyle: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocConsumer<IncomeCubit, IncomeState>(
                  listener: (context, state) {
                    if (state.status == IncomeStatus.success) {
                      context.read<IncomeCubit>().getIncomes();
                    }
                  },
                  builder: (context, state) => state.status ==
                          IncomeStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : SaveButton(
                          gradient: true,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              income.amount = double.parse(
                                  incomeController.text.replaceAll(',', '.'));

                              context.read<IncomeCubit>().createIncome(income);
                              Navigator.pop(context);
                            }
                          },
                          label: 'Save Income',
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
