import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/components/place_holder.dart';
import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
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
    popupTypePicker() {
      showTypePicker(formStore);
    }

    var content = type == null
        ? placeholder(onPressed: popupTypePicker, text: "请选择类型")
        : TextButton(
            onPressed: popupTypePicker,
            child: Row(
              children: [
                Icon(
                  type.iconData,
                  size: 24,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  type.name,
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
          );

    return Label(
      text: "类型",
      child: content,
    );
  }

  void showTypePicker(FormStore formStore) {
    SmartDialog.show(builder: (context) {
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
              typeLabel(context, matterTypeItem: item, onPressed: (type) async {
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
      {required MatterTypeItem matterTypeItem,
      required Function(MatterTypeItem) onPressed}) {
    final icon = matterTypeItem.iconData;
    final text = matterTypeItem.name;
    return TextButton(
      onPressed: () async {
        onPressed(matterTypeItem);
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
