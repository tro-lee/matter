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

  List<MatterModel> _mattersList = [];
  List<MatterModel> get mattersList => _mattersList;

  Future<void> initializeMattersList() async {
    if (_mattersList.isEmpty) {
      final matters = await MatterService.getMattersByDay(DateTime.now());
      _mattersList = matters;
      notifyListeners();
    }
  }

  static Future<void> refresh() async {
    if (_instance != null) {
      final matters = await MatterService.getMattersByDay(DateTime.now());
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
