import 'package:buhuiwangshi/pages/home/page.dart';
import 'package:buhuiwangshi/services/notification.dart';
import 'package:buhuiwangshi/store.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timezone/data/latest_all.dart' as tz;

/// 应用程序入口点
void main() async {
  // 加载环境变量
  await dotenv.load(fileName: ".env");

  // 设置Jiffy库的本地化
  Jiffy.setLocale('zh_CN');

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
    const TextTheme textTheme = TextTheme(
      titleLarge: TextStyle(fontSize: 26),
      titleMedium: TextStyle(fontSize: 24),
      titleSmall: TextStyle(fontSize: 22),
      bodyLarge: TextStyle(fontSize: 20),
      bodyMedium: TextStyle(fontSize: 18),
      bodySmall: TextStyle(fontSize: 16),
    );
    return MaterialApp(
      // 添加SmartDialog观察者
      navigatorObservers: [FlutterSmartDialog.observer],
      // 初始化SmartDialog
      builder: FlutterSmartDialog.init(),
      // 设置应用主题
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        textTheme: textTheme,
        fontFamily: "PingFang",
      ),
      // 使用系统主题模式
      themeMode: ThemeMode.system,
      // 设置主页
      home: standardContainer(
        context: context,
        child: const HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 设置系统UI样式
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    // 初始化通知服务
    NotificationService.initialize();

    // 初始化时区
    tz.initializeTimeZones();
  }
}
