import 'package:flutter/material.dart';

Color darkenColor(int colorValue, double factor) {
  assert(factor >= 0 && factor <= 1);

  Color color = Color(colorValue);
  final r = (color.red * (1 - factor)).round();
  final g = (color.green * (1 - factor)).round();
  final b = (color.blue * (1 - factor)).round();

  return Color.fromARGB(color.alpha, r, g, b);
}
