import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';

/// 底部层
class BottomLayer extends StatelessWidget {
  final Widget child;
  const BottomLayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: containerColor(context),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: Container(
        alignment: Alignment.bottomLeft,
        height: 100,
        child: child,
      ),
    );
  }
}
