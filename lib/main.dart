import 'package:buhuiwangshi/page.dart';
import 'package:buhuiwangshi/store.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:jiffy/jiffy.dart';

import 'utils/theme.dart';

/// 应用程序入口点
void main() {
  runApp(
    const SystemStoreWrapper(child: MyApp()),
  );
}

/// 应用程序的根组件
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // 设置系统UI样式
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    // 设置Jiffy库的本地化
    Jiffy.setLocale('zh_CN');

    return MaterialApp(
      // 添加SmartDialog观察者
      navigatorObservers: [FlutterSmartDialog.observer],
      // 初始化SmartDialog
      builder: FlutterSmartDialog.init(),
      // 设置应用主题
      theme: ThemeData(
        colorScheme: MaterialTheme.lightScheme(),
        fontFamily: "PingFang",
      ),
      // 设置主页
      home: standardContainer(context: context, child: const Home()),
    );
  }
}
