import 'dart:core';

import 'package:buhuiwangshi/pages/home/top_layer.dart';
import 'package:buhuiwangshi/store/home_page_store.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/date.dart';

/// 头部区域
class HeadArea extends StatelessWidget {
  const HeadArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      height: 100,
      child: Text(
        "你好",
        style: TextStyle(fontSize: 24, color: textColor(context)),
      ),
    );
  }
}

class UnderPage extends StatelessWidget {
  const UnderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: const HeadArea(),
    );
  }
}

/// 日历区域
class CalArea extends StatelessWidget {
  const CalArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getCalWeekItem(context),
      ),
    );
  }

  List<Widget> getCalWeekItem(BuildContext context) {
    final weekNum = ["一", "二", "三", "四", "五", "六", "日"];
    final week = generateOneWeeksDates();

    List<List<String>> datas = [];

    for (var a = 0; a < 7; a++) {
      List<String> data = [];
      data.add(weekNum[a]);
      data.add(week[a].toString());
      datas.add(data);
    }

    return datas
        .map(
          (data) => CalItem(data: data),
        )
        .toList();
  }
}

/// 需要存储当前是否选中状态, 需要Stateful
class CalItem extends StatefulWidget {
  final List<String> data;

  const CalItem({super.key, this.data = const []});

  @override
  State<CalItem> createState() => _CalItemState();
}

class _CalItemState extends State<CalItem> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      throw Exception("数据异常");
    }

    final now = DateTime.now();
    isSelected = widget.data[1] == now.day.toString();

    var fontColor = isSelected ? textColor(context) : labelColor(context);

    return Container(
      width: 36,
      margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      decoration: isSelected
          ? BoxDecoration(
              color: containerColor(context),
              borderRadius: const BorderRadius.all(Radius.circular(12)))
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.data[0],
            style: TextStyle(color: fontColor, fontSize: 12, height: 1),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            widget.data[1],
            style: TextStyle(color: fontColor, fontSize: 18, height: 1),
          ),
        ],
      ),
    );
  }
}

class MiddlePage extends StatelessWidget {
  const MiddlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: middleContainerColor(context),
      ),
      margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
      child: const CalArea(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePageStoreWrapper(
      child: standardContainer(
        child: Container(
          color: containerColor(context),
          height: double.infinity,
          width: double.infinity,
          child: const Stack(
            children: [UnderPage(), MiddlePage(), TopLayer()],
          ),
        ),
        context: context,
      ),
    );
  }
}
