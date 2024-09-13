import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReminderLevelArea extends StatelessWidget {
  const ReminderLevelArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<AddPageStore>(context);
    final level = formStore.level;
    final setLevel = formStore.setLevel;

    final backgroundColor =
        level == 'low' ? Color(formStore.color) : const Color(0xffDECBD5);
    final indicatorColor = level == 'low'
        ? Color(formStore.fontColor)
        : const Color.fromARGB(255, 155, 115, 137);

    final text = level == 'low' ? "静音提醒" : "响铃提醒";
    final icon = level == 'low' ? Icons.notifications_off : Icons.notifications;

    return Label(
        text: "强度",
        labelStyle: LabelStyle(labelWidth: 110, safeWidth: 50),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: AnimatedToggleSwitch.dual(
              borderWidth: 0,
              current: level,
              style: ToggleStyle(
                  backgroundColor: backgroundColor,
                  indicatorColor: indicatorColor),
              first: "low",
              second: "high",
              onChanged: setLevel,
              iconBuilder: (value) =>
                  Icon(icon, color: onPrimaryColor(context)),
              textBuilder: (value) => Text(text,
                  style: TextStyle(color: indicatorColor, fontSize: 18))),
        ));
  }
}
