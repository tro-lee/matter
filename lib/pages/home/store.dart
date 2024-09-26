import 'package:buhuiwangshi/models/matter_model.dart';
import 'package:buhuiwangshi/services/matter.dart';
import 'package:buhuiwangshi/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// HomePageStore 类负责管理首页的状态
/// 它是一个单例类，继承自 ChangeNotifier，用于通知监听器状态的变化
class HomePageStore extends ChangeNotifier {
  /// 私有静态实例，用于实现单例模式
  static HomePageStore? _instance;

  /// 获取 HomePageStore 的单例实例
  /// 如果实例不存在，则创建一个新的实例
  static HomePageStore get instance {
    _instance ??= HomePageStore();
    return _instance!;
  }

  /// 标记 HomePageStore 是否已经初始化
  bool isInitialized = false;

  /// 私有变量，存储当前的事项列表
  List<MatterModel> _mattersList = [];

  /// 获取当前的事项列表
  List<MatterModel> get mattersList => _mattersList;

  /// 私有变量，存储当前选中的日期
  /// 初始化为当前日期的零点时间
  DateTime _selectedDate = getZeroTime(DateTime.now());

  /// 获取当前选中的日期
  DateTime get selectedDate => _selectedDate;

  /// 标记是否正在加载数据
  bool _isLoading = false;

  /// 获取是否正在加载数据
  bool get isLoading => _isLoading;

  /// 初始化事项列表
  static Future<void> initializeMattersList() async {
    // 如果已经初始化，则直接返回
    if (instance.isInitialized) {
      return;
    }

    await refresh();

    // 标记为已初始化
    instance.isInitialized = true;
    return;
  }

  /// 选择日期
  /// [date] 要选择的新日期
  static Future<void> selectDate(DateTime date) async {
    if (_instance == null) return;

    // 将日期设置为零点时间
    DateTime newDate = getZeroTime(date);

    // 如果新日期与当前选中日期相同，则不进行操作
    if (newDate == _instance!._selectedDate) return;

    // 更新选中的日期
    _instance!._selectedDate = newDate;
    _instance!.notifyListeners();

    await HapticFeedback.heavyImpact();

    await refresh();
  }

  /// 刷新事项列表
  /// [date] 可选参数，指定刷新的日期，不传则刷新当前选中的日期
  static Future<void> refresh({DateTime? date}) async {
    // 如果实例存在，则进行刷新操作
    if (_instance != null) {
      var isLoading = true;

      // 延迟1秒后通知监听器状态已更新
      Future.delayed(const Duration(milliseconds: 120), () {
        if (_instance != null && isLoading) {
          _instance!._isLoading = true;
          _instance!.notifyListeners();
        }
      });

      // 从服务中获取指定日期（或当前选中日期）的事项列表
      final matters =
          await MatterService.getMattersByDay(date ?? _instance!._selectedDate);
      _instance!._mattersList = matters;
      isLoading = false;
      _instance!._isLoading = false;
      _instance!.notifyListeners();
    }
  }

  /// 完成打卡事项
  static Future<void> finishMatter(String matterId) async {
    print("finishMatter: $matterId");
    if (_instance == null) return;

    // 查找指定 ID 的事项
    final matterIndex =
        _instance!._mattersList.indexWhere((m) => m.id == matterId);
    if (matterIndex == -1) return;

    // 更新事项状态
    _instance!._mattersList[matterIndex].isDone = true;
    _instance!._mattersList[matterIndex].isDeleted = false;
    _instance!._mattersList[matterIndex].doneAt = DateTime.now();

    // 更新数据库
    await MatterService.updateMatter(_instance!._mattersList[matterIndex]);

    // 通知监听器状态已更新
    _instance!.notifyListeners();
  }

  // 取消完成事项
  static Future<void> cancelMatter(String matterId) async {
    print("cancelMatter: $matterId");
    if (_instance == null) return;

    // 查找指定 ID 的事项
    final matterIndex =
        _instance!._mattersList.indexWhere((m) => m.id == matterId);
    if (matterIndex == -1) return;

    // 更新事项状态
    _instance!._mattersList[matterIndex].isDone = false;
    _instance!._mattersList[matterIndex].isDeleted = false;
    _instance!._mattersList[matterIndex].doneAt = null;

    // 更新数据库
    await MatterService.updateMatter(_instance!._mattersList[matterIndex]);

    // 通知监听器状态已更新
    _instance!.notifyListeners();
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
