import 'package:buhuiwangshi/components/place_holder.dart';
import 'package:buhuiwangshi/store/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/input_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemarkArea extends StatelessWidget {
  const RemarkArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormStore>(context);
    final remark = formStore.remark;
    final setRemark = formStore.setRemark;

    /// 核心内容判断
    var content = remark.isEmpty
        ? CustomPlaceholder(
            onPressed: () => showTextInput(
                context: context, setValue: setRemark, value: remark),
            text: "可输入备注")
        : TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => showTextInput(
                context: context, setValue: setRemark, value: remark),
            child: Text(remark,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: 18, color: Color(formStore.fontColor))),
          );

    /// 壳子，预设的壳子无法满足要求
    return Container(
      color: topContainerColor(context),
      child: Row(
        crossAxisAlignment: remark.isEmpty
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Container(
            width: 96,
            padding: const EdgeInsets.fromLTRB(24, 16, 0, 16),
            child: const Text("备注", style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(
            width: 64,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 14, 8),
            child: content,
          )),
        ],
      ),
    );
  }
}
