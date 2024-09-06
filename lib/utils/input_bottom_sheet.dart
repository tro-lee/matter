import 'package:buhuiwangshi/utils/system.dart';
import 'package:flutter/material.dart';

showTextInput({context, required String value, setValue}) async {
  if (SystemUtils.hasFocus) {
    SystemUtils.hideKeyShowUnfocus();
    await Future.delayed(const Duration(milliseconds: 100));
  }

  TextEditingController controller =
      TextEditingController.fromValue(TextEditingValue(text: value));

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
                onChanged: setValue,
                keyboardType: TextInputType.text,
                autofocus: true,
              ),
            ),
          ),
        );
      });
}
