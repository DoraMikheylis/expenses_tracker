import 'dart:math';

import 'package:flutter/material.dart';

LinearGradient linearGradient(BuildContext context) => LinearGradient(
      colors: [
        Theme.of(context).colorScheme.tertiary,
        Theme.of(context).colorScheme.tertiaryContainer,
        Theme.of(context).colorScheme.onTertiary,
      ],
      transform: const GradientRotation(pi / 4),
    );

LinearGradient reverseLinearGradient(BuildContext context, int rotation) =>
    LinearGradient(
      colors: [
        Theme.of(context).colorScheme.onTertiary,
        Theme.of(context).colorScheme.tertiaryContainer,
        Theme.of(context).colorScheme.tertiary,
      ],
      transform: GradientRotation(pi / rotation),
    );
