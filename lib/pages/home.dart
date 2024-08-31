import 'package:flutter/material.dart';
import 'package:namer_app/utils/colors.dart';
import 'package:namer_app/utils/date.dart';

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
        style: TextStyle(fontSize: 32),
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
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getCalWeekItem(context),
      ),
    );
  }

  List<Widget> getCalWeekItem(BuildContext context) {
    final weekNum = ["一", "二", "三", "四", "五", "六", "日"];
    final weeks = generateFourWeeksDates();

    List<List<String>> datas = [];

    for (var a = 0; a < 7; a++) {
      List<String> data = [];
      data.add(weekNum[a]);
      for (var week in weeks) {
        data.add(week[a].toString());
      }
      datas.add(data);
    }

    return datas
        .map((data) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data[0],
                  style: TextStyle(
                      color: labelColor(context), fontSize: 16, height: 1),
                ),
                Text(
                  data[1],
                  style: TextStyle(
                      color: labelColor(context), fontSize: 28, height: 1),
                ),
              ],
            ))
        .toList();
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
      margin: EdgeInsets.fromLTRB(64, 164, 0, 0),
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
          margin: EdgeInsets.fromLTRB(0, 164, 0, 0),
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
