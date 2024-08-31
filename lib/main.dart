import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

import 'utils/theme.dart';
import 'pages/home.dart';

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
    return MaterialApp(
      theme: ThemeData(
        colorScheme: MaterialTheme.lightScheme(),
      ),
      home: Home(),
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

  final _barContainer = Colors.white;
  final _onBarContainer = Colors.black;

  /// 底部导航栏 完成对selectedPage的控制
  Widget bottomBar() {
    onTap(int index) {
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

    return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(780)),
        child: CustomNavigationBar(
            // 动画逻辑
            scaleCurve: Curves.fastEaseInToSlowEaseOut,
            scaleFactor: 0.1,
            iconSize: 32,
            selectedColor: _onBarContainer,
            unSelectedColor: _onBarContainer,
            strokeColor: _barContainer,
            backgroundColor: _barContainer,
            // 事项与选择逻辑
            items: items,
            currentIndex: _currentIndex,
            onTap: onTap));
  }
}
