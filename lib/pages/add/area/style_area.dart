import 'package:buhuiwangshi/components/color_picker.dart';
import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/store/add/store.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

class StyleArea extends StatelessWidget {
  const StyleArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormStore>(context);

    var textButton = OutlinedButton(
      style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(formStore.fontColor), width: 2),
          padding: EdgeInsets.zero,
          shadowColor: Colors.white),
      onPressed: () async {
        if (SystemUtils.hasFocus) {
          SystemUtils.hideKeyShowUnfocus();
          await Future.delayed(const Duration(milliseconds: 100));
        }
        SmartDialog.show(
            animationTime: const Duration(milliseconds: 120),
            builder: (context) => ColorPicker(
                  onFinish: formStore.setFontColor,
                ));
      },
      child: Text("文本",
          style: TextStyle(fontSize: 18, color: Color(formStore.fontColor))),
    );

    var elevatedButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shadowColor: Colors.white,
          backgroundColor: Color(formStore.color)),
      onPressed: () async {
        if (SystemUtils.hasFocus) {
          SystemUtils.hideKeyShowUnfocus();
          await Future.delayed(const Duration(milliseconds: 100));
        }
        SmartDialog.show(
            animationTime: const Duration(milliseconds: 120),
            builder: (context) => ColorPicker(
                  onFinish: formStore.setColor,
                ));
      },
      child: Text("背景",
          style: TextStyle(fontSize: 18, color: Color(formStore.fontColor))),
    );

    return Label(
        text: "样式",
        child: Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            textButton,
            const SizedBox(
              width: 16,
            ),
            elevatedButton,
            IconButton(
                onPressed: () {
                  formStore.resetColor();
                },
                icon: Icon(
                  Icons.restart_alt_outlined,
                  color: Color(formStore.fontColor),
                ))
          ],
        ));
  }
}
