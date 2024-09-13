import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemStore extends ChangeNotifier {
  static final SystemStore _instance = SystemStore();
  static SystemStore get instance => _instance;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
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
