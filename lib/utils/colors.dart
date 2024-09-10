import 'package:flutter/material.dart';

Color containerColor(context) {
  return Theme.of(context).colorScheme.primaryContainer;
}

Color onContainerColor(context) {
  return Theme.of(context).colorScheme.onPrimaryContainer;
}

Color primaryColor(context) {
  return Theme.of(context).colorScheme.primary;
}

Color onPrimaryColor(context) {
  return Theme.of(context).colorScheme.onPrimary;
}

Color textColor(context) {
  return Colors.black87;
}

Color middleContainerColor(context) {
  return const Color(0xFFEBF1FF);
}

Color topContainerColor(context) {
  return const Color(0xFFF5F8FF);
}

Color labelColor() {
  return Colors.black45;
}

Color opacityColor50() {
  return Colors.white.withOpacity(0.5);
}

Color blendColors(Color color1, Color color2, double ratio) {
  final r = (color1.red + (color2.red - color1.red) * ratio).round();
  final g = (color1.green + (color2.green - color1.green) * ratio).round();
  final b = (color1.blue + (color2.blue - color1.blue) * ratio).round();
  final a = (color1.alpha + (color2.alpha - color1.alpha) * ratio).round();
  return Color.fromARGB(a, r, g, b);
}
