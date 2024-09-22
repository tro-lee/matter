import 'dart:core';

import 'package:buhuiwangshi/pages/home/head_layer.dart';
import 'package:buhuiwangshi/pages/home/bottom_bar_layer.dart';
import 'package:buhuiwangshi/pages/home/content_layer.dart';
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
            children: [
              ContentLayer(),
              HeadLayer(),
              BottomBarLayer(),
            ],
          ),
        ),
        context: context,
      ),
    );
  }
}
