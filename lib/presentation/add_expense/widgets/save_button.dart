import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function? onPressed;
  final String label;

  const SaveButton({
    super.key,
    this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //вся доступная ширина
      width: double.infinity,
      height: kToolbarHeight,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
