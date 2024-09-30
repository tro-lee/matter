import 'package:flutter/material.dart';

Color containerColor(context) {
  return Theme.of(context).colorScheme.primaryContainer;
}

Color onContainerColor(context) {
  return Theme.of(context).colorScheme.onPrimaryContainer;
}

const inversePrimaryColor = Color(0xffaac7ff);
const onInversePrimaryColor = Color(0xff44474e);

const primaryColor = Color(0xff415f91); // primary
const onPrimaryColor = Color(0xffffffff); // on primary

const primaryContainerColor = Color(0xFFd6e3ff); // primary container
const onPrimaryContainerColor = Color(0xff001b3e); // on primary container

const surfaceColor = Color(0xFFf9f9ff); // surface
const onSurfaceColor = Color(0xff191c20); // on surface
const surfaceDimColor = Color(0xfff3f3fa); // on surface

const textColor = Color(0xff191c20); // on surface
const textColor2 = Color(0xff44474e); // on surface
const labelColor = Color(0xff74777f); // outline

Color blendColors(Color color1, Color color2, double ratio) {
  final r = (color1.red + (color2.red - color1.red) * ratio).round();
  final g = (color1.green + (color2.green - color1.green) * ratio).round();
  final b = (color1.blue + (color2.blue - color1.blue) * ratio).round();
  final a = (color1.alpha + (color2.alpha - color1.alpha) * ratio).round();
  return Color.fromARGB(a, r, g, b);
}
