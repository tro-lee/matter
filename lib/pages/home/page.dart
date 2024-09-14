import 'dart:core';

import 'package:buhuiwangshi/components/under_page.dart';
import 'package:buhuiwangshi/pages/home/middle_layer.dart';
import 'package:buhuiwangshi/pages/home/top_layer.dart';
import 'package:buhuiwangshi/pages/home/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePageStoreWrapper(
      child: standardContainer(
        child: const Stack(
          /// 每层维护自身高度和交互逻辑，互不打扰
          /// 最上层是顶部层，中间是日历层，最下层是底部层
          children: [
            UnderPage(),
            MiddlePage(),
            TopLayer(),
          ],
        ),
        context: context,
      ),
    );
  }
}

class UnderPage extends StatelessWidget {
  const UnderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomLayer(
      child: Text(
        "😊 不会忘事~",
        style: TextStyle(fontSize: 22, color: textColor),
      ),
    );
  }
}
