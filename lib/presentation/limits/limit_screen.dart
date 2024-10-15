import 'package:expenses_tracker/presentation/limits/widgets/day_limit.dart';
import 'package:expenses_tracker/presentation/linear_gradient.dart';
import 'package:flutter/material.dart';

class LimitScreen extends StatefulWidget {
  const LimitScreen({super.key});

  @override
  State<LimitScreen> createState() => _LimitScreenState();
}

class _LimitScreenState extends State<LimitScreen> {
  // TextEditingController expenseController = TextEditingController();
  // TextEditingController categoryController = TextEditingController();
  // TextEditingController dateController = TextEditingController();

  // @override
  // void initState() {
  //   dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
  //   getListIcons(context).then((value) => categoriesIcons = value);
  //   expense = Expense.empty;
  //   expense.expenseId = const Uuid().v1();
  //   super.initState();
  // }
  List<String> limits = [
    'Day limit',
    'Week limit',
    'Month limit',
    'Year limit'
  ];
  int? value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Limits',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 5.0,
              children: List.generate(limits.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        value = value == index ? null : index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient:
                            value == index ? linearGradient(context) : null,
                        color: value == index ? null : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        limits[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: value == index
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            const SingleChildScrollView(
              child: Column(
                children: [
                  DayLimit(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
