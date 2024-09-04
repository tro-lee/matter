import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:jiffy/jiffy.dart';

import 'utils/theme.dart';
import 'pages/home.dart';
import 'pages/add/add.dart';

void main() {
  runApp(const MyApp());
}

/// App设置
class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));

    Jiffy.setLocale('zh_CN');

    return MaterialApp(
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      theme: ThemeData(
          colorScheme: MaterialTheme.lightScheme(), fontFamily: "PingFang"),
      home: standardContainer(context: context, child: Home()),
    );
  }
}

/// 页面设置
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 底部导航 和 组件映射关系
  final map =
      {0: HomePage(), 1: Placeholder(), 2: Placeholder()} as Map<int, Widget>;
  // 当前页面
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentPage = map[_currentIndex] ?? HomePage();

    return Scaffold(
      extendBody: true,
      body: currentPage,
      bottomNavigationBar: bottomBar(),
    );
  }

  Route animateRoute({required Widget child}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  /// 底部导航栏 完成对selectedPage的控制
  Widget bottomBar() {
    const barContainer = Colors.white;
    const onBarContainer = Colors.black;

    onTap(int index) {
      if (index == 1) {
        Future.delayed(Duration.zero, () {
          Navigator.push(context, animateRoute(child: AddPage()));
        });
        index = _currentIndex;
      }
      setState(() {
        _currentIndex = index;
      });
    }

    var items = [
      CustomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
      ),
      CustomNavigationBarItem(
        icon: Icon(
          Icons.add_circle_outline,
        ),
        selectedIcon: Icon(
          Icons.add_circle,
        ),
      ),
      CustomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
      )
    ];

    var customNavigationBar = CustomNavigationBar(
        // 动画逻辑
        scaleCurve: Curves.fastEaseInToSlowEaseOut,
        scaleFactor: 0.1,
        iconSize: 28,
        selectedColor: onBarContainer,
        unSelectedColor: onBarContainer,
        strokeColor: barContainer,
        backgroundColor: barContainer,
        // 事项与选择逻辑
        items: items,
        currentIndex: _currentIndex,
        onTap: onTap);

    return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(780)),
        child: customNavigationBar);
  }
}
