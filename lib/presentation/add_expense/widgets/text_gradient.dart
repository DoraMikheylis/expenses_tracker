import 'package:expenses_tracker/presentation/linear_gradient.dart';
import 'package:flutter/material.dart';

class TextGradient extends StatelessWidget {
  const TextGradient(
    this.text, {
    super.key,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => linearGradient(context).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
