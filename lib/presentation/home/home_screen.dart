import 'package:expenses_tracker/business_logic/auth_bloc/auth_bloc.dart';
import 'package:expenses_tracker/business_logic/auth_bloc/auth_event.dart';
import 'package:expenses_tracker/business_logic/auth_bloc/auth_state.dart';
import 'package:expenses_tracker/business_logic/expense_bloc/expense_bloc.dart';
import 'package:expenses_tracker/constants/routes.dart';
import 'package:expenses_tracker/presentation/auth/show_error_dialog.dart';
import 'package:expenses_tracker/presentation/home/widgets/balance_card.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_item.dart';
import 'package:expenses_tracker/presentation/widgets/show_confirm_dialog.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          top: 25.0,
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateSignedOut) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (_) => false,
              );
            } else if (state is AuthStateSignedOut && state.exception != null) {
              showErrorDialog(context, state.exception.toString());
            } else if (state is AuthStateSignedIn) {}
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MenuAnchor(
                    alignmentOffset: const Offset(10, 0),
                    menuChildren: [
                      MenuItemButton(
                        onPressed: () async {
                          final shouldLogout = await showConfirmDialog(
                              context: context,
                              title: 'Log out',
                              content: 'Are you sure you want to log out?',
                              firstAction: 'Cancel',
                              secondAction: 'Log out');
                          if (shouldLogout && context.mounted) {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventSignOut());
                          }
                        },
                        child: const Text('Log out'),
                      ),
                    ],
                    builder: (BuildContext context, MenuController controller,
                        Widget? child) {
                      return TextButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.yellow[700]),
                                ),
                                Icon(
                                  CupertinoIcons.person_fill,
                                  color: Colors.yellow[900],
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome!',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                                ),
                                Text(
                                  user?.displayName ??
                                      user?.email.toString() ??
                                      'Unknown user',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton.filled(
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.surfaceBright)),
                    color: Theme.of(context).colorScheme.outline,
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.settings,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              balanceCard(context),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'View All',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
                if (state is GetExpensesSuccess) {
                  return TransactionList(
                    transactions: state.expenses
                        .map((e) => expenseToTransactionItem(e))
                        .toList(),
                    slidableActions: (itemId) {
                      return [
                        SlidableAction(
                          onPressed: (context) {
                            context
                                .read<ExpenseBloc>()
                                .add(DeleteExpenseEvent(expenseId: itemId));
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ];
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
