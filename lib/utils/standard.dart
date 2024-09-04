import 'package:flutter/material.dart';

// 标准容器 统一字大小
Widget standardContainer({required context, required child}) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
    child: child,
  );
}
