import 'package:buhuiwangshi/components/matter.dart';
import 'package:buhuiwangshi/constant/matter_type.dart';
import 'package:buhuiwangshi/constant/templates.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatterTemplatesPage extends StatelessWidget {
  // 回调函数
  const MatterTemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AddPageStoreWrapper(
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
      icon: const Icon(
        Icons.arrow_circle_left_outlined,
        color: textColor,
      ),
    );
    // 中间标题
    var text = const Text(
      "选择模板",
      style: TextStyle(fontSize: 24, color: textColor),
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
    final formStore = Provider.of<AddPageStore>(context);

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
      color: surfaceColor,
      child: TemplateList(onFinish: onFinish),
    );
  }
}

class TemplateList extends StatelessWidget {
  final Function(MatterType, DateTime, String) onFinish;

  const TemplateList({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final templates = getTemplates();

    return ListView.builder(
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () =>
              onFinish(template.type, template.time, template.name),
          child: Matter(
            color: Color(template.type.color),
            fontColor: Color(template.type.fontColor),
            type: template.type,
            time: template.time,
            name: template.name,
            showBottomLine: index != templates.length - 1,
            bottomLineColor: index < templates.length - 1
                ? Color(templates[index + 1].type.color)
                : Colors.transparent,
          ),
        );
      },
    );
  }
}
