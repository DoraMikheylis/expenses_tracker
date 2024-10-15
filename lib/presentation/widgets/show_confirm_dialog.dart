import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required String firstAction,
    required String secondAction}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(child: Text(title)),
        content: Text(content),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(firstAction)),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(secondAction)),
        ],
      );
    },
  ).then((value) => value ?? false);
}
