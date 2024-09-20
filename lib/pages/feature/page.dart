import 'package:buhuiwangshi/pages/feature/buttons_area.dart';
import 'package:buhuiwangshi/pages/feature/chart.dart';
import 'package:buhuiwangshi/pages/feature/more_area.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return standardContainer(
      context: context,
      child: const TopPage(),
    );
  }
}

/// 顶部层
class TopPage extends StatelessWidget {
  const TopPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        color: surfaceDimColor,
      ),
      height: double.infinity,
      width: double.infinity,
      child: const SafeArea(
        child: Column(children: [
          Chart(), // 图表
          SizedBox(height: 32),
          ButtonsArea(), // 按钮区
          SizedBox(height: 32),
          MoreArea() // 更多功能
        ]),
      ),
    );
  }
}
