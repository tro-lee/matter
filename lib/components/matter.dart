import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Matter extends StatelessWidget {
  final Color color;
  final Color fontColor;
  final DateTime? time;
  final MatterType type;
  final String name;
  final IconData levelIcon;

  const Matter(
      {super.key,
      required this.type,
      required this.color,
      required this.fontColor,
      required this.time,
      required this.name,
      required this.levelIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      width: double.infinity,
      child: Row(
        children: [
          line(
              context: context,
              icon: type.iconData,
              backgroundColor: color,
              fontColor: fontColor),
          content(
              context: context,
              templateName: name,
              datetime: time,
              levelIcon: levelIcon,
              color: color,
              fontColor: fontColor),
        ],
      ),
    );
  }

  /// 线
  Widget line(
      {context,
      required IconData icon,
      required Color backgroundColor,
      required Color fontColor}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 8,
            height: double.infinity,
            color: middleContainerColor(context),
          ),
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(180)),
            ),
            width: 64,
            height: 64,
            child: Icon(icon, size: 32, color: fontColor),
          ),
        ],
      ),
    );
  }

  /// 内容
  Widget content(
      {required context,
      required String templateName,
      required DateTime? datetime,
      required IconData levelIcon,
      required Color color,
      required Color fontColor}) {
    var name = templateName.isEmpty ? "点我选择模板" : templateName;

    String time = '00:00';
    if (datetime != null) {
      var timeJiffy = Jiffy.parseFromDateTime(datetime);
      time = timeJiffy.format(pattern: "HH:mm a");
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(120))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      textScaler: const TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: fontColor,
                        fontSize: 24,
                      )),
                  time.isEmpty
                      ? const SizedBox()
                      : Text(time,
                          textScaler: const TextScaler.linear(1),
                          style: TextStyle(
                            fontSize: 18,
                            color: fontColor,
                          ))
                ],
              ),
            ),
            Icon(
              levelIcon,
              color: fontColor,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
