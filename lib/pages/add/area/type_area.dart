import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/components/place_holder.dart';
import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:buhuiwangshi/store/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TypeArea extends StatelessWidget {
  const TypeArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var formStore = Provider.of<FormStore>(context);
    var type = formStore.type;

    var content = type == null
        ? CustomPlaceholder(
            onPressed: () => showTypePicker(formStore),
            text: "请选择类型",
            isWarning: formStore.isTypeWarning,
          )
        : TextButton(
            onPressed: () => showTypePicker(formStore),
            child: Row(
              children: [
                Icon(
                  type.iconData,
                  size: 24,
                  color: Color(formStore.fontColor),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  type.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(formStore.fontColor),
                  ),
                )
              ],
            ),
          );

    return Label(
      text: "类型",
      child: content,
    );
  }

  void showTypePicker(FormStore formStore) async {
    if (SystemUtils.hasFocus) {
      SystemUtils.hideKeyShowUnfocus();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    SmartDialog.show(
        animationTime: const Duration(milliseconds: 120),
        builder: (context) {
          return standardContainer(
            context: context,
            child: Container(
              decoration: BoxDecoration(
                  color: topContainerColor(context),
                  borderRadius: const BorderRadius.all(Radius.circular(24))),
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
              width: 256,
              child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
                for (var item in matterTypeItems)
                  typeLabel(context, matterType: item, onPressed: (type) async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    SmartDialog.dismiss();
                    formStore.setType(type);
                  })
              ]),
            ),
          );
        });
  }

  // 标签
  Widget typeLabel(BuildContext context,
      {required MatterType matterType,
      required Function(MatterType) onPressed}) {
    final icon = matterType.iconData;
    final text = matterType.name;
    return TextButton(
      onPressed: () async {
        onPressed(matterType);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: IntrinsicWidth(
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: primaryColor(context),
              ),
              const SizedBox(width: 4),
              Text(text,
                  style: TextStyle(fontSize: 18, color: primaryColor(context))),
            ],
          ),
        ),
      ),
    );
  }
}
