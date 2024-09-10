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
      child: const Stack(
        children: [
          UnderPage(),
          TopPage(),
        ],
      ),
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: middleContainerColor(context),
      ),
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: const Column(children: [
        Chart(), // 图表
        SizedBox(height: 32),
        ButtonsArea(), // 按钮区
        SizedBox(height: 32),
        MoreArea() // 更多功能
      ]),
    );
  }
}

/// 底部层
class UnderPage extends StatelessWidget {
  const UnderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: containerColor(context),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.topCenter,
      child: Container(
        alignment: Alignment.bottomLeft,
        height: 100,
        child: Text(
          "👋 探索更多功能吧！~",
          style: TextStyle(fontSize: 24, color: textColor(context)),
        ),
      ),
    );
  }
}
