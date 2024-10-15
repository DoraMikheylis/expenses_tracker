import 'package:flutter/material.dart';

class DayLimit extends StatefulWidget {
  const DayLimit({super.key});

  @override
  State<DayLimit> createState() => _DayLimitState();
}

class _DayLimitState extends State<DayLimit> {
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<bool> selectedDays = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('В какие дни лимит хочешь?'),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 5.0,
          children: List.generate(days.length, (index) {
            return FilterChip(
              showCheckmark: false,
              backgroundColor: Colors.white,
              label: Text(
                days[index],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              selected: selectedDays[index],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              side: BorderSide.none,
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                setState(() {
                  selectedDays[index] = selected;
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
