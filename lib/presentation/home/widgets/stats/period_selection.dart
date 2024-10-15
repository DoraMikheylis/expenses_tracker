// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:custom_date_range_picker/custom_date_range_picker.dart';

// class PeriodSelection extends StatefulWidget {
//   const PeriodSelection({super.key});

//   @override
//   State<StatefulWidget> createState() => _PeriodSelectionState();
// }

// class _PeriodSelectionState extends State<PeriodSelection> {
//   String selectedPeriod = 'Last 7 Days';
//   DateTimeRange? customRange;
//   DateTime? startDate;
//   DateTime? endDate;

//   List<String> predefinedPeriods = [
//     'Last 7 Days',
//     'Last Month',
//     'Last Year',
//     'Custom Range'
//   ];

//   Future<void> _selectCustomDateRange(BuildContext context) async {
//     return showCustomDateRangePicker(
//       context,
//       dismissible: true,
//       minimumDate: DateTime.now().subtract(const Duration(days: 30)),
//       maximumDate: DateTime.now().add(const Duration(days: 30)),
//       endDate: endDate,
//       startDate: startDate,
//       backgroundColor: Colors.white,
//       primaryColor: Colors.green,
//       onApplyClick: (start, end) {
//         setState(() {
//           endDate = end;
//           startDate = start;
//         });
//       },
//       onCancelClick: () {
//         setState(() {
//           endDate = null;
//           startDate = null;
//         });
//       },
//     );
//   }

//   // if (picked != null) {
//   //   setState(() {
//   //     customRange = picked;
//   //     selectedPeriod = 'Custom Range';
//   //   });
//   // }

//   String _getSelectedPeriodText() {
//     if (selectedPeriod == 'Custom Range' && customRange != null) {
//       final DateFormat formatter = DateFormat('dd.MM.yyyy');
//       return 'From ${formatter.format(customRange!.start)} to ${formatter.format(customRange!.end)}';
//     }
//     return selectedPeriod;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         DropdownButton<String>(
//           value: selectedPeriod,
//           items:
//               predefinedPeriods.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             if (newValue == 'Custom Range') {
//               _selectCustomDateRange(context);
//             } else {
//               setState(() {
//                 selectedPeriod = newValue!;
//                 customRange = null;
//               });
//             }
//           },
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Selected Period: ${_getSelectedPeriodText()}',
//           style: const TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }
// }
