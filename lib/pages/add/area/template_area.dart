import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class TemplateArea extends StatelessWidget {
  const TemplateArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormStore>(context);
    final name = formStore.name ?? '';
    final time = formStore.datetime;
    final icon = formStore.icon;
    final levelIcon = formStore.level == 'low'
        ? Icons.notifications_off_outlined
        : Icons.notifications_outlined;

    final color = Color(formStore.color);
    final fontColor = Color(formStore.fontColor);

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
          color: topContainerColor(context),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Row(
        children: [
          line(
              context: context,
              icon: icon,
              backgroundColor: color,
              fontColor: fontColor),
          content(
              context: context,
              templateName: name,
              datetime: time,
              levelIcon: levelIcon,
              color: color,
              fontColor: fontColor)
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
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(120))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: fontColor,
                          fontSize: 24,
                        )),
                    time.isEmpty
                        ? const SizedBox()
                        : Text(time,
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
      ),
    );
  }
}
