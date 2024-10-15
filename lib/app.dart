import 'package:expenses_tracker/business_logic/auth_bloc/auth_bloc.dart';
import 'package:expenses_tracker/business_logic/auth_bloc/auth_event.dart';
import 'package:expenses_tracker/business_logic/category_bloc/category_bloc.dart';
import 'package:expenses_tracker/business_logic/expense_bloc/expense_bloc.dart';
import 'package:expenses_tracker/business_logic/income_cubit/income_cubit.dart';
import 'package:expenses_tracker/business_logic/stats_cubit/stats_cubit.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/data/repositories/expense_repository.dart';
import 'package:expenses_tracker/data/repositories/firebase_expense_repo.dart';
import 'package:expenses_tracker/presentation/add_expense/add_expense_screen.dart';
import 'package:expenses_tracker/presentation/add_income/add_income_screen.dart';
import 'package:expenses_tracker/presentation/auth/login_screen.dart';
import 'package:expenses_tracker/presentation/home/widgets/nav_bar.dart';
import 'package:expenses_tracker/presentation/auth/registration_screen.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/expense_list_by_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc(FirebaseExpenseRepo())
            ..add(
              const GetExpensesEvent(),
            ),
        ),
        BlocProvider<IncomeCubit>(
          create: (context) => IncomeCubit(FirebaseExpenseRepo())..getIncomes(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(const AuthEventInitialize()),
        ),
        BlocProvider<StatsCubit>(
          create: (context) => StatsCubit(FirebaseExpenseRepo()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            surface: Colors.grey.shade100,
            onSurface: Colors.black,
            surfaceBright: Colors.white,
            // primary: Colors.white,
            onPrimary: const Color(0xFF2B405B),
            onSecondary: const Color(0xFF456690),
            // secondary: const Color(0xFFE064F7),
            tertiary: const Color(0xFFFF8D6C),
            onTertiary: const Color(0xFF00B2E7),
            tertiaryContainer: const Color(0xFFE064F7),
            outline: Colors.grey,
          ),
        ),
        routes: {
          defaultRoute: (context) => BlocProvider<AuthBloc>.value(
                value: context.read<AuthBloc>(),
                child: const LoginScreen(),
              ),
          loginRoute: (context) => BlocProvider<AuthBloc>.value(
                value: context.read<AuthBloc>(),
                child: const LoginScreen(),
              ),
          registerRoute: (context) => const RegistationScreen(),
          homeRoute: (context) => BlocProvider<StatsCubit>.value(
                value: context.read<StatsCubit>(),
                child: const NavBarMainScreen(),
              ),
          expensesByCategoryRoute: (context) => BlocProvider<StatsCubit>.value(
                value: context.read<StatsCubit>(),
                child: const ExpenseListByCategory(),
              ),
          addExpenseRoute: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<StatsCubit>.value(
                    value: context.read<StatsCubit>(),
                  ),
                  BlocProvider<CategoryBloc>(
                    create: (context) => CategoryBloc(FirebaseExpenseRepo())
                      ..add(const GetCategoriesEvent()),
                  ),
                  BlocProvider<ExpenseBloc>.value(
                    value: context.read<ExpenseBloc>(),
                  ),
                ],
                child: const AddExpenseScreen(),
              ),
          statsRoute: (context) => BlocProvider<StatsCubit>.value(
                value: context.read<StatsCubit>(),
                child: const NavBarMainScreen(),
              ),
          addIncomeRoute: (context) => BlocProvider<IncomeCubit>.value(
              value: context.read<IncomeCubit>(),
              child: const AddIncomeScreen()),
        },
      ),
    );
  }
}
