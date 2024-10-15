import 'package:expenses_tracker/presentation/linear_gradient.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool? gradient;

  const SaveButton({
    super.key,
    this.onPressed,
    required this.label,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        //вся доступная ширина
        decoration: gradient == true
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: linearGradient(context),
              )
            : BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
        width: double.infinity,
        height: kToolbarHeight,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
