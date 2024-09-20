import 'dart:core';

import 'package:buhuiwangshi/pages/home/bottom_layer.dart';
import 'package:buhuiwangshi/pages/home/chat_layer.dart';
import 'package:buhuiwangshi/pages/home/calendar_layer.dart';
import 'package:buhuiwangshi/pages/home/top_layer.dart';
import 'package:buhuiwangshi/pages/home/store.dart';
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
