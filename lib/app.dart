import 'package:expenses_tracker/business_logic/category_bloc/category_bloc.dart';
import 'package:expenses_tracker/business_logic/expense_bloc/expense_bloc.dart';
import 'package:expenses_tracker/data/repositories/firebase_expense_repo.dart';
import 'package:expenses_tracker/presentation/add_expense/add_expense_screen.dart';
import 'package:expenses_tracker/presentation/home/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final ExpenseBloc _expenseBloc = ExpenseBloc(FirebaseExpenseRepo());

  @override
  void dispose() {
    _expenseBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade100,
          onBackground: Colors.black,
          primary: const Color(0xFF00B2E7),
          secondary: const Color(0xFFE064F7),
          tertiary: const Color(0xFFFF8D6C),
          outline: Colors.grey,
        ),
      ),
      routes: {
        '/': (context) => BlocProvider.value(
              value: _expenseBloc..add(GetExpensesEvent()),
              child: const NavBarMainScreen(),
            ),
        '/add_expense': (context) => BlocProvider(
              create: (context) => CategoryBloc(FirebaseExpenseRepo())
                ..add(const GetCategoriesEvent()),
              child: BlocProvider.value(
                value: _expenseBloc,
                child: const AddExpenseScreen(),
              ),
            ),
      },
    );
  }
}
