import 'package:buhuiwangshi/pages/home/bottom_layer.dart';
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
          BackgroundLayer(),
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
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          color: surfaceColor,
        ),
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(0, 42, 0, 0),
        child: const Column(children: [
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

/// 底部层
class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomLayer(
      child: Text(
        "👋 探索更多功能吧！~",
        style: TextStyle(fontSize: 22),
      ),
    );
  }
}
