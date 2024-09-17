import 'dart:async';
import 'dart:convert';

import 'package:buhuiwangshi/ai/ai.dart';
import 'package:buhuiwangshi/models/matter_ai_model.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AiService {
  static Future<void> use(
      {required String prompt, required Function() onCallback}) async {
    try {
      // 获取生成内容
      final result = await AI.generateContent(messages: prompt);

      /// 判断为 生成日程型
      if (result.containsKey('createMatters')) {
        final matters = result['createMatters'];
        SmartDialog.showToast(matters.toString());

        final matterAiJsons = jsonDecode(matters);
        final matterAis =
            matterAiJsons.map((e) => MatterAiModel.fromJson(e)).toList();
      }

      /// 判断为 其他
      if (result.containsKey('other')) {
        SmartDialog.showToast(result['other'].toString());
      }

      onCallback();
    } catch (e) {
      print(e);
    }
  }
}
