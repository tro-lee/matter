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
    final icon = formStore.type?.iconData ?? Icons.edit;

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
          color: topContainerColor(context),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Row(
        children: [line(context, icon), content(context, name, time)],
      ),
    );
  }

  /// 线
  Widget line(context, IconData icon) {
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
              color: middleContainerColor(context),
              borderRadius: BorderRadius.all(Radius.circular(180)),
            ),
            width: 64,
            height: 64,
            child: Icon(icon, size: 32, color: primaryColor(context)),
          ),
        ],
      ),
    );
  }

  /// 内容
  Widget content(context, templateName, datetime) {
    var name = templateName.isEmpty ? "点我选择模板" : templateName;

    String time = '00:00';
    if (datetime != null) {
      var timeJiffy = Jiffy.parseFromDateTime(datetime!);
      time = timeJiffy.format(pattern: "HH:mm a");
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
        decoration: BoxDecoration(
            color: middleContainerColor(context),
            borderRadius: BorderRadius.all(Radius.circular(120))),
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
                          color: primaryColor(context),
                          fontSize: 24,
                        )),
                    time.isEmpty
                        ? SizedBox()
                        : Text(time,
                            style: TextStyle(
                              fontSize: 18,
                              color: primaryColor(context),
                            ))
                  ],
                ),
              ),
              Icon(
                Icons.notifications_none,
                color: primaryColor(context),
                size: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}
