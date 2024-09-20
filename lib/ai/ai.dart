import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// AI类：用于生成内容的人工智能接口
class AI {
  /// 基础URL：用于发送请求的API端点
  static const String _baseUrl =
      'https://dashscope.aliyuncs.com/api/v1/apps/51306d1e836c4845a6e7d68722672d90/completion';

  /// 通过文本输入，解析有以下情况
  /// 1. 生成日程
  /// 2. 生成其他内容

  /// 生成内容的方法
  /// 参数：
  ///   messages: 消息
  /// 返回：
  ///  JSON格式
  /// {
  ///   "createMatters":
  ///   {
  ///     "matters": [
  ///       {
  ///         "name": "名称",
  ///         "type": "类型",
  ///         "time": "时间",
  ///         "remark": "备注",
  ///       }
  ///     ],
  ///     "extparams": {
  ///       "isWeeklyRepeat": "是否每周重复",
  ///       "weeklyRepeatDays": "每周重复的日期",
  ///       "isDailyClusterRepeat": "是否每天重复",
  ///     }
  ///   }
  /// }
  static Future<Map<String, dynamic>> generateContent({
    required String messages,
  }) async {
    final apiKey = dotenv.env['ALI_API_KEY'];
    if (apiKey == null) {
      throw Exception('环境变量中未找到API密钥');
    }

    final client = HttpClient();
    try {
      /// 请求组装
      final request = await client.postUrl(Uri.parse(_baseUrl));
      request.headers.set('Authorization', 'Bearer $apiKey');
      request.headers.set('Content-Type', 'application/json');

      final newMessages =
          "当前时间为${DateTime.now().toIso8601String()},请根据以上时间进行计算; 用户输入：$messages";

      final jsonBody = jsonEncode({
        'input': {'prompt': newMessages}
      });
      request.add(utf8.encode(jsonBody));

      /// 请求发送
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      /// 请求结果
      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(responseBody);
          return jsonDecode(jsonResponse['output']['text']);
        } catch (e) {
          throw Exception('生成内容失败: $e');
        }
      } else {
        throw Exception('生成内容失败: ${response.statusCode}\n错误: $responseBody');
      }
    } catch (e) {
      throw Exception('未知错误: $e');
    } finally {
      client.close();
    }
  }
}
