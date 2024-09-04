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

Color labelColor(context) {
  return Colors.black45;
}

Color opacityColor50() {
  return Colors.white.withOpacity(0.5);
}
