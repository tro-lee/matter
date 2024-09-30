import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemStore extends ChangeNotifier {
  static final SystemStore _instance = SystemStore();
  static SystemStore get instance => _instance;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  static void setCurrentIndex(int index) {
    if (_instance._currentIndex != index) {
      _instance._currentIndex = index;
      _instance.notifyListeners();
    }
  }
}

class SystemStoreWrapper extends StatelessWidget {
  final Widget child;
  const SystemStoreWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: SystemStore.instance, child: child);
  }
}
