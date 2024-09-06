import 'package:buhuiwangshi/pages/add/area/remark_area.dart';
import 'package:buhuiwangshi/pages/add/area/reminder_level_area.dart';
import 'package:buhuiwangshi/pages/add/area/style_area.dart';
import 'package:buhuiwangshi/store/add/store.dart';
import 'package:buhuiwangshi/store/add/wrapper.dart';
import 'package:flutter/material.dart';

import 'package:buhuiwangshi/pages/add/area/name_area.dart';
import 'package:buhuiwangshi/pages/add/area/time_area.dart';
import 'package:buhuiwangshi/pages/add/area/template_area.dart';
import 'package:buhuiwangshi/pages/add/area/type_area.dart';

import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:provider/provider.dart';

// 添加页
class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return AddStoreWrapper(
      child: standardContainer(
        context: context,
        child: const Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: TopAppBar(),
          body: Body(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    FormStore.reset();
    super.dispose();
  }
}

/// 以下是头部部分
class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormStore>(context);

    // 左侧按钮
    var iconButton = IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_circle_left_outlined,
        color: textColor(context),
      ),
    );
    // 中间标题
    var text = Text(
      "添加日程",
      style: TextStyle(fontSize: 24, color: textColor(context)),
    );

    onSave() {
      formStore
          .setIsNameWarning(formStore.name == null || formStore.name!.isEmpty);
      formStore.setIsTimeWarning(formStore.datetime == null);
      formStore.setIsTypeWarning(formStore.type == null);

      if (formStore.isNameWarning ||
          formStore.isTimeWarning ||
          formStore.isTypeWarning) {
        return;
      }

      Navigator.of(context).pop();
    }

    // 右侧保存
    var textButton = TextButton(
        onPressed: onSave,
        child: Text("完成",
            style: TextStyle(fontSize: 18, color: textColor(context))));

    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      leading: iconButton,
      centerTitle: true,
      title: text,
      actions: [textButton],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 64);
}

/// 以下是内容部分
class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    const height = 12.0;

    /// 各个区域
    var column = const Column(
      children: [
        TemplateArea(),
        SizedBox(height: height),
        NameArea(),
        SizedBox(height: height),
        TimeArea(),
        SizedBox(height: height),
        TypeArea(),
        SizedBox(height: height),
        ReminderLevelArea(),
        SizedBox(height: height),
        StyleArea(),
        SizedBox(height: height),
        RemarkArea(),
      ],
    );

    return Container(
      color: Colors.white,
      child: column,
    );
  }
}
