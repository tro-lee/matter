import 'package:buhuiwangshi/datebase/matter.dart';
import 'package:buhuiwangshi/service/matter.dart';
import 'package:flutter/material.dart';

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

  Future<void> refresh() async {
    final matters = await MatterService.getMattersByDay(DateTime.now());
    _mattersList = matters;
    notifyListeners();
  }

  setMattersList(List<MatterModel> value) {
    _mattersList = value;
    notifyListeners();
  }
}
