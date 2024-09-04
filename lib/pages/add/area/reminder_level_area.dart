import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/components/place_holder.dart';
import 'package:flutter/material.dart';

class ReminderLevelArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Label(text: "提醒强度", child: placeholder(text: "轻触选择提醒强度"));
  }
}
