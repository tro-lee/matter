import 'package:buhuiwangshi/models/matter_model.dart';
import 'package:buhuiwangshi/services/matter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DetailsPageStore extends ChangeNotifier {
  MatterModel? _data;

  MatterModel? get data => _data;

  Future<MatterModel?> loadData(String matterId) async {
    try {
      _data = await MatterService.getMatterById(matterId);
      notifyListeners();
      return _data;
    } catch (e) {
      // 错误处理
      return null;
    }
  }

  /// 完成打卡事项
  Future<void> finishMatter() async {
    if (_data == null) return;
    _data!.isDone = true;
    _data!.isDeleted = false; // 确保取消状态被重置
    _data!.doneAt = DateTime.now();
    await _updateMatter();
  }

  /// 取消打卡事项
  Future<void> cancelMatter() async {
    if (_data == null) return;
    _data!.isDeleted = true;
    _data!.isDone = false; // 确保完成状态被重置
    await _updateMatter();
  }

  /// 重置打卡事项
  Future<void> resetMatter() async {
    if (_data == null) return;
    _data!.isDone = false;
    _data!.isDeleted = false;
    await _updateMatter();
  }

  /// 更新事项并通知监听器
  Future<void> _updateMatter() async {
    await MatterService.updateMatter(_data!);
    await HapticFeedback.selectionClick();
    notifyListeners();
  }
}
