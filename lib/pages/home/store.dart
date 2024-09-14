import 'package:buhuiwangshi/datebase/matter.dart';
import 'package:buhuiwangshi/service/matter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageStore extends ChangeNotifier {
  static HomePageStore? _instance;
  static HomePageStore get instance {
    _instance ??= HomePageStore();
    return _instance!;
  }

  bool isInitialized = false;
  List<MatterModel> _mattersList = [];
  List<MatterModel> get mattersList => _mattersList;

  static Future<void> initializeMattersList() async {
    if (instance.isInitialized) {
      return;
    }

    if (instance._mattersList.isEmpty) {
      final matters = await MatterService.getMattersByDay(DateTime.now());
      instance._mattersList = matters;
      instance.notifyListeners();
    }
    instance.isInitialized = true;
  }

  static Future<void> refresh({DateTime? date}) async {
    if (_instance != null) {
      final matters =
          await MatterService.getMattersByDay(date ?? DateTime.now());
      // Sort matters by time
      _instance!._mattersList = matters;
      _instance!.notifyListeners();
    }
  }

  setMattersList(List<MatterModel> value) {
    _mattersList = value;
    notifyListeners();
  }
}

class HomePageStoreWrapper extends StatelessWidget {
  final Widget child;
  const HomePageStoreWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: HomePageStore.instance, child: child);
  }
}
