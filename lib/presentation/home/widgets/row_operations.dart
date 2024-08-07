import 'package:flutter/material.dart';

Row rowOperationsMainScreen(
    {required String title,
    required String amount,
    required Color? iconColor,
    required IconData icon}) {
  return Row(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white30),
          ),
          Center(
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
        ],
      ),
      const SizedBox(
        width: 12,
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ]),
    ],
  );
}
