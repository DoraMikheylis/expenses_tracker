import 'package:expenses_tracker/data/data_providers/api/get_list_icons.dart';
import 'package:expenses_tracker/business_logic/expense_bloc/expense_bloc.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';
import 'package:expenses_tracker/presentation/add_expense/widgets/category_creation_show_dialog.dart';
import 'package:expenses_tracker/presentation/add_expense/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../business_logic/category_bloc/category_bloc.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late Expense expense;

  late final Map<String, String> categoriesIcons;

  @override
  void initState() {
    dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
    getListIcons(context).then((value) => categoriesIcons = value);
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //чтобы по нажатию вне формы, убирался фокус с формы, гестур детектор + фокусскоуп
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar:
            AppBar(backgroundColor: Theme.of(context).colorScheme.background),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Add Expenses',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                //размер экрана
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  controller: expenseController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        FontAwesomeIcons.dollarSign,
                        size: 16,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none)),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is GetCategoriesSuccess) {
                    return Column(
                      children: [
                        TextFormField(
                          readOnly: true,
                          onTap: () {},
                          controller: categoryController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: expense.category == Category.empty
                                ? Colors.white
                                : Color(expense.category.color),
                            prefixIcon: expense.category == Category.empty
                                ? const Icon(
                                    FontAwesomeIcons.list,
                                    size: 16,
                                    color: Colors.grey,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      width: 5.0,
                                      height: 5.0,
                                      categoriesIcons[expense.category.icon] ??
                                          '',
                                      colorFilter: const ColorFilter.mode(
                                          Colors.green, BlendMode.srcIn),
                                    ),
                                  ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.plus,
                                size: 16,
                                color: Colors.grey,
                              ),
                              onPressed: () async {
                                await categoryCreation(
                                    context, categoriesIcons);
                              },
                            ),
                            hintText: 'Category',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: state.categories.length,
                              itemBuilder: ((context, int i) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        expense.category = state.categories[i];
                                        categoryController.text =
                                            expense.category.name.toString();
                                      });
                                    },
                                    leading: SvgPicture.asset(
                                      width: 24,
                                      height: 24,
                                      categoriesIcons[
                                              state.categories[i].icon] ??
                                          '',
                                      colorFilter: const ColorFilter.mode(
                                          Colors.green, BlendMode.srcIn),
                                    ),
                                    title: Text(
                                        state.categories[i].name.toString()),
                                    tileColor: Color(state.categories[i].color),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: expense.date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)));

                  if (newDate != null) {
                    setState(() {
                      dateController.text =
                          DateFormat('dd/MM/yyyy').format(newDate);
                      expense.date = newDate;
                    });
                  }
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      FontAwesomeIcons.calendar,
                      size: 16,
                      color: Colors.grey,
                    ),
                    hintText: 'Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none)),
              ),
              const SizedBox(
                height: 32,
              ),
              BlocConsumer<ExpenseBloc, ExpenseState>(
                listener: (context, state) {
                  if (state is CreateExpenseSuccess) {
                    context.read<ExpenseBloc>().add(GetExpensesEvent());
                    Navigator.pop(context);
                  }
                  if (state is CreateExpenseFailure) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(state.message),
                    //   ),
                    // );
                  }
                },
                builder: (context, state) => state is CreateExpenseLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SaveButton(
                        onPressed: () {
                          setState(() {
                            expense.amount = int.parse(expenseController.text);

                            context
                                .read<ExpenseBloc>()
                                .add(CreateExpenseEvent(expense: expense));
                          });
                        },
                        label: 'Save expense',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
