import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:buhuiwangshi/store/add/store.dart';
import 'package:buhuiwangshi/pages/matter_templates/templates.dart';
import 'package:buhuiwangshi/store/add/wrapper.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatterTemplates extends StatelessWidget {
  // 回调函数
  const MatterTemplates({super.key});

  @override
  Widget build(BuildContext context) {
    return AddStoreWrapper(
      child: standardContainer(
          context: context,
          child: const Scaffold(appBar: TopAppBar(), body: Body())),
    );
  }
}

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
      "选择模板",
      style: TextStyle(fontSize: 24, color: textColor(context)),
    );

    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      leading: iconButton,
      centerTitle: true,
      title: text,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 64);
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormStore>(context);

    final templates = getTemplates();

    onFinish(MatterType type, time, name) {
      formStore.setCustom(
          color: type.color,
          fontColor: type.fontColor,
          type: type,
          time: time,
          name: name);
      Navigator.of(context).pop();
    }

    return Container(
        color: topContainerColor(context),
        child: ListView(
          children: [for (var matter in templates) matter(onFinish)],
        ));
  }
}
