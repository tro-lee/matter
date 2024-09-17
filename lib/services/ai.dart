import 'dart:async';

import 'package:buhuiwangshi/ai/ai.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// AI 服务
/// 根据 输入，提供多种服务
class AiService {
  static Future<void> use(
      {required String prompt, Function()? onCallback}) async {
    try {
      // 获取生成内容
      final result = await AI.generateContent(messages: prompt);

      /// 判断为 生成日程型
      if (result.containsKey('createMatters')) {
        final matters = result['createMatters'];
        SmartDialog.showToast(matters.toString());

        // final matterAiJsons = jsonDecode(matters);
        // final matterAis =
        //     matterAiJsons.map((e) => MatterAiModel.fromJson(e)).toList();
      }

      /// 判断为 其他
      if (result.containsKey('other')) {
        SmartDialog.showToast(result['other'].toString());
      }

      onCallback?.call();
    } catch (e) {
      print(e);
    }
  }
}
