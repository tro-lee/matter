import 'dart:core';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: HeadArea(),
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
      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
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

class CalItem extends StatefulWidget {
  final List<String> data;

  CalItem({super.key, this.data = const []});

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
      margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
      decoration: isSelected
          ? BoxDecoration(
              color: containerColor(context),
              borderRadius: BorderRadius.all(Radius.circular(12)))
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.data[0],
            style: TextStyle(color: fontColor, fontSize: 12, height: 1),
          ),
          SizedBox(
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: middleContainerColor(context),
      ),
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
      child: CalArea(),
    );
  }
}

/// 时间线
class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(64, 148, 0, 0),
      width: 4,
      height: double.infinity,
      color: middleContainerColor(context),
    );
  }
}

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(64)),
            color: topContainerColor(context),
          ),
          margin: EdgeInsets.fromLTRB(0, 148, 0, 0),
          width: double.infinity,
          height: double.infinity,
        ),
        TimeLine()
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: containerColor(context),
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [UnderPage(), MiddlePage(), TopPage()],
      ),
    );
  }
}
