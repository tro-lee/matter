import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameArea extends StatelessWidget {
  const NameArea({super.key});

  @override
  Widget build(BuildContext context) {
    final setName = Provider.of<FormStore>(context).setName;

    return Label(
        text: "名称",
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          child: TextField(
            onChanged: setName,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration.collapsed(
                hintText: "请输入名称", hintStyle: TextStyle(color: Colors.black38)),
          ),
        ));
  }
}
