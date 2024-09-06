import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/components/place_holder.dart';
import 'package:buhuiwangshi/store/add/store.dart';
import 'package:buhuiwangshi/utils/input_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NameArea extends StatelessWidget {
  const NameArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormStore>(context);
    final setName = Provider.of<FormStore>(context).setName;
    final name = Provider.of<FormStore>(context).name ?? '';

    var content = name.isEmpty
        ? placeholder(
            isWarning: formStore.isNameWarning,
            onPressed: () =>
                showTextInput(context: context, setValue: setName, value: name),
            text: "请输入名称")
        : TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () =>
                showTextInput(context: context, setValue: setName, value: name),
            child: Text(name,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 18, color: Color(formStore.fontColor))),
          );

    return Label(text: "名称", child: content);
  }
}
