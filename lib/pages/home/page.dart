import 'dart:core';

import 'package:buhuiwangshi/pages/home/bottom_layer.dart';
import 'package:buhuiwangshi/pages/home/chat_layer.dart';
import 'package:buhuiwangshi/pages/home/calendar_layer.dart';
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
        child: const Scaffold(
          body: Stack(
            /// 每层维护自身高度和交互逻辑，互不打扰
            /// 最上层是顶部层，中间是日历层，最下层是底部层
            children: [BackgroundLayer(), CalendarLayer(), TopLayer()],
          ),
          bottomNavigationBar: ChatLayer(),
        ),
        context: context,
      ),
    );
  }
}

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomLayer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "不会忘事",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1),
              ),
              Text(
                "今天又是元气满满的一天",
                style: TextStyle(fontSize: 16, color: labelColor, height: 1),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu, size: 24, color: labelColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
