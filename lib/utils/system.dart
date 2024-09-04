import 'package:flutter/material.dart';

class SystemUtils {
  /// 关闭键盘并失去焦点
  static Future<void> hideKeyShowUnfocus() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // 判断是否有焦点
  static get hasFocus {
    return FocusManager.instance.primaryFocus?.hasFocus ?? false;
  }
}
