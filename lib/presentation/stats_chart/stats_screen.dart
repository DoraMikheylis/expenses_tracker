// import 'package:expenses_tracker/presentation/stats/widgets/chart.dart';
// import 'package:flutter/material.dart';

// class StatScreen extends StatelessWidget {
//   const StatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(
//             'Transactions',
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.onSurface),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height / 2,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(25)),
//             child: const Padding(
//               padding: EdgeInsets.all(15.0),
//               child: Chart(),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
