import 'package:expenses_tracker/business_logic/currency_cubit/currency_cubit.dart';
import 'package:expenses_tracker/business_logic/expense_bloc/expense_bloc.dart';
import 'package:expenses_tracker/business_logic/income_cubit/income_cubit.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/presentation/home/home_screen.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/stats_screen.dart';
import 'package:expenses_tracker/presentation/linear_gradient.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarMainScreen extends StatefulWidget {
  const NavBarMainScreen({super.key});

  @override
  State<NavBarMainScreen> createState() => _NavBarMainScreenState();
}

class _NavBarMainScreenState extends State<NavBarMainScreen> {
  int index = 0;

  Color selectedItemColor = Colors.blue;
  Color unSelectedItemColor = Colors.grey;

  ValueNotifier<bool> isChildTapped = ValueNotifier(false);

  @override
  void initState() {
    context.read<ExpenseBloc>().add(const GetExpensesEvent());
    context.read<IncomeCubit>().getIncomes();
    context.read<CurrencyCubit>().getRates(currencies: 'USD,EUR,RUB');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as int?;
    if (routeArgs != null) {
      setState(() => index = routeArgs);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: Colors.grey.shade300,
            spreadRadius: 2,
            offset: const Offset(3, 10),
          ),
        ]),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(35),
          ),
          child: NavigationBar(
            height: 50,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            indicatorColor: Colors.transparent,
            indicatorShape: const CircleBorder(),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: index,
            onDestinationSelected: (value) {
              setState(() {
                index = value;
              });
            },
            backgroundColor: Colors.white,
            destinations: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: NavigationDestination(
                  icon: Icon(
                    CupertinoIcons.home,
                    color: index == 0 ? selectedItemColor : unSelectedItemColor,
                  ),
                  label: 'Home',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: NavigationDestination(
                  icon: Icon(CupertinoIcons.graph_square_fill,
                      color:
                          index == 1 ? selectedItemColor : unSelectedItemColor),
                  label: 'Stats',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SpeedDial(
        onClose: () => setState(() {
          isChildTapped.value = false;
        }),
        buttonSize: const Size(65, 65),
        childrenButtonSize: Size(MediaQuery.of(context).size.width * 0.8,
            MediaQuery.of(context).size.height * 0.08),
        spacing: 10,
        iconTheme: const IconThemeData(color: Colors.white),
        direction: SpeedDialDirection.up,
        closeManually: true,
        openCloseDial: isChildTapped,
        children: [
          SpeedDialChild(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: rowSpeedDialChildren(context, () {
              setState(() {
                isChildTapped.value = false;
              });
            }, index),
            onTap: () {},
          )
        ],
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: linearGradient(context),
          ),
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
      body: index == 0 ? const HomeScreen() : const StatsScreen(),
    );
  }
}

Wrap rowSpeedDialChildren(
    BuildContext context, VoidCallback onPressed, int index) {
  return Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 50,
    children: [
      SizedBox(
        height: 65,
        width: 65,
        child: FittedBox(
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              onPressed();
              Navigator.pushNamed(
                context,
                addIncomeRoute,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, gradient: linearGradient(context)),
              child: const Center(
                child: Text(
                  'Add\nIncome',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 65,
        width: 65,
        child: FittedBox(
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              onPressed();
              Navigator.pushNamed(
                context,
                addExpenseRoute,
                arguments: index,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, gradient: linearGradient(context)),
              child: const Center(
                child: Text(
                  'Add\nExpense',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
