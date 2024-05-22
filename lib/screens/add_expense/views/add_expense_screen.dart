import 'package:expenses_repository/expense_repository.dart';
import 'package:expenses_tracker/api/get_list_icons.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/views/category_creation.dart';
import 'package:expenses_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../blocs/get_categories_bloc/get_categories_bloc.dart';

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
        body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
          builder: (context, state) {
            if (state is GetCategoriesSuccess) {
              return Padding(
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
                              await categoryCreation(context, categoriesIcons);
                            },
                          ),
                          hintText: 'Category',
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              borderSide: BorderSide.none)),
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
                                  categoriesIcons[state.categories[i].icon] ??
                                      '',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.green, BlendMode.srcIn),
                                ),
                                title:
                                    Text(state.categories[i].name.toString()),
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
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)));

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
                    BlocConsumer<CreateExpenseBloc, CreateExpenseState>(
                      listener: (context, state) {
                        if (state is CreateExpenseSuccess) {
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
                                  expense.amount =
                                      int.parse(expenseController.text);

                                  context
                                      .read<CreateExpenseBloc>()
                                      .add(CreateExpense(expense: expense));

                                  context
                                      .read<GetExpensesBloc>()
                                      .add(GetExpenses());
                                });
                              },
                              label: 'Save expense',
                            ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

createCategory({
  required BuildContext context,
  required String categoryName,
  required String categoryIcon,
  required int categoryColor,
}) {
  Category category = Category.empty;
  category.categoryId = const Uuid().v1();

  category.name = categoryName;
  category.icon = categoryIcon;
  category.color = categoryColor;

  context.read<CreateCategoryBloc>().add(CreateCategory(category));
}

class SaveButton extends StatelessWidget {
  final Function? onPressed;
  final String label;

  const SaveButton({
    super.key,
    this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //вся доступная ширина
      width: double.infinity,
      height: kToolbarHeight,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
