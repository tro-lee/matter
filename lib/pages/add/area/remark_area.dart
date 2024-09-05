import 'package:buhuiwangshi/components/place_holder.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemarkArea extends StatelessWidget {
  const RemarkArea({super.key});

  @override
  Widget build(BuildContext context) {
    final remark = Provider.of<FormStore>(context).remark;
    final setRemark = Provider.of<FormStore>(context).setRemark;

    /// 核心内容判断
    var content = remark.isEmpty
        ? placeholder(
            onPressed: () => showTextInput(
                context: context, setRemark: setRemark, remark: remark),
            text: "可输入备注")
        : TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => showTextInput(
                context: context, setRemark: setRemark, remark: remark),
            child: Text(remark,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, color: primaryColor(context))),
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

  /// 点击备注后，弹窗输入消息
  showTextInput({context, required String remark, setRemark}) async {
    if (SystemUtils.hasFocus) {
      SystemUtils.hideKeyShowUnfocus();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    TextEditingController controller =
        TextEditingController.fromValue(TextEditingValue(text: remark));

    showModalBottomSheet(
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return AnimatedPadding(
            curve: Curves.easeIn,
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration.zero,
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: controller,
                  onEditingComplete: () {
                    Navigator.of(context).pop();
                  },
                  minLines: 1,
                  maxLines: null,
                  onChanged: setRemark,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                ),
              ),
            ),
          );
        });
  }
}
