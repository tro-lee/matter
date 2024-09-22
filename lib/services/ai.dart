import 'dart:async';
import 'dart:convert';

import 'package:buhuiwangshi/ai/ai.dart';
import 'package:buhuiwangshi/models/matter_ai_model.dart';
import 'package:buhuiwangshi/models/matter_builder_model.dart';
import 'package:buhuiwangshi/pages/home/store.dart';
import 'package:buhuiwangshi/services/matter.dart';
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
        final createMatters = jsonDecode(result['createMatters']);

        final matters = createMatters['matters'];
        final extraParams = createMatters['params'];
        matters.forEach((e) {
          e['isWeeklyRepeat'] = extraParams['isWeeklyRepeat'];
          e['weeklyRepeatDays'] = extraParams['weeklyRepeatDays'];
          e['isDailyClusterRepeat'] = extraParams['isDailyClusterRepeat'];
        });

        final matterBuilders = <MatterBuilderModel>[];
        for (var e in matters) {
          matterBuilders.add(MatterAiModel.fromJson(e).toMatterBuilderModel());
        }

        // 插入数据
        await MatterService.insertMatterBuilders(matterBuilders);

        // 获取第一条数据的日期
        if (matterBuilders.isNotEmpty) {
          final firstMatterDate = matterBuilders.first.time;
          // 刷新并跳转到第一条数据的日期
          await HomePageStore.refresh(date: firstMatterDate);
        }
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
