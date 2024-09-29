import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static var androidNotificationDetails = const AndroidNotificationDetails(
      'buhuiwangshi', '不会忘事',
      channelDescription: '不会忘事通知',
      styleInformation: DefaultStyleInformation(true, true),
      enableVibration: true,
      importance: Importance.max,
      playSound: true,
      visibility: NotificationVisibility.public,
      ticker: '不会忘事',
      enableLights: true,
      category: AndroidNotificationCategory.message,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: false);

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await checkPermission();

    // 安卓初始化
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    print('初始化通知服务');
  }

  static Future<void> checkPermission() async {
    print('检查通知权限');

    if (flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>() ==
        null) {
      print('安卓通知服务初始化失败');
      return;
    }

    try {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestFullScreenIntentPermission();
      print('请求全屏权限');
    } catch (e) {
      print('检查通知权限失败: $e');
    }

    try {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      print('请求通知权限');
    } catch (e) {
      print('检查通知权限失败: $e');
    }
  }

  static Future<void> showNotification(String title, String body) async {
    await checkPermission();
    print('显示通知');
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000000),
      title,
      DateTime.now().toIso8601String(),
      NotificationDetails(
        android: androidNotificationDetails,
      ),
      payload: 'payload',
    );

    // await flutterLocalNotificationsPlugin.periodicallyShow(
    //   Random().nextInt(1000000),
    //   title,
    //   body,
    //   RepeatInterval.everyMinute,
    //   NotificationDetails(
    //     android: androidNotificationDetails,
    //   ),
    // );

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   Random().nextInt(1000000),
    //   title,
    //   body,
    //   TZDateTime.now(getLocation('Asia/Shanghai'))
    //       .add(const Duration(seconds: 5)),
    //   NotificationDetails(
    //     android: androidNotificationDetails,
    //   ),
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //   uiLocalNotificationDateInterpretation:
    //       UILocalNotificationDateInterpretation.absoluteTime,
    // );
  }
}
