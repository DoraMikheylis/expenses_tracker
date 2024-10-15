import 'package:expenses_tracker/business_logic/category_bloc/category_bloc.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/data/data_providers/api/get_list_icons.dart';
import 'package:expenses_tracker/business_logic/expense_bloc/expense_bloc.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';
import 'package:expenses_tracker/presentation/add_expense/widgets/category_form_field.dart';
import 'package:expenses_tracker/presentation/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController expenseController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late Expense expense;

  Map<String, String> categoriesIcons = {};
  final _formKey = GlobalKey<FormState>();
  late String sourceScreen;

  bool isEditing = false;
  late AnimationController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    getListIcons(context).then((value) => categoriesIcons = value);
    expense = Expense.createEmpty();
    expense.expenseId = const Uuid().v1();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    expenseController.dispose();
    dateController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as int?;
    sourceScreen = routeArgs == 0 ? 'HomeScreen' : 'StatsScreen';

    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              'Add Expense',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: MediaQuery.of(context).size.height * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        //размер экрана
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          focusNode: _focusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the expense amount';
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
                          controller: expenseController,
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
                      categoryFormField(
                          context: context,
                          categoriesIcons: categoriesIcons,
                          expense: expense,
                          isEditing: isEditing,
                          toggleEditing: _toggleEditing,
                          onRemoveCategory: (category) {
                            context
                                .read<CategoryBloc>()
                                .add(DeleteCategoryEvent(category));

                            setState(() {
                              context
                                  .read<CategoryBloc>()
                                  .add(const GetCategoriesEvent());
                            });
                          },
                          onCategorySelected: (category) {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              expense.category = category;
                            });
                          },
                          controller: _controller),
                      const SizedBox(
                        height: 16,
                      ),
                      EasyDateTimeLine(
                        initialDate: expense.date,
                        onDateChange: (DateTime newDate) {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            dateController.text =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            expense.date = newDate;
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  BlocConsumer<ExpenseBloc, ExpenseState>(
                    listener: (context, state) {
                      if (state is CreateExpenseSuccess) {
                        if (sourceScreen == 'HomeScreen') {
                          context
                              .read<ExpenseBloc>()
                              .add(const GetExpensesEvent());

                          Navigator.pop(context);
                        }
                        if (sourceScreen == 'StatsScreen') {
                          Navigator.pushReplacementNamed(context, statsRoute,
                              arguments: 1);
                        }
                      }
                      if (state is CreateExpenseFailure) {}
                    },
                    builder: (context, state) => state is CreateExpenseLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SaveButton(
                            gradient: true,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                expense.amount = double.parse(expenseController
                                    .text
                                    .replaceAll(',', '.'));
                                context
                                    .read<ExpenseBloc>()
                                    .add(CreateExpenseEvent(expense: expense));
                              }
                            },
                            label: 'Save expense',
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
