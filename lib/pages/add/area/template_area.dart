import 'package:animations/animations.dart';
import 'package:buhuiwangshi/components/matter.dart';
import 'package:buhuiwangshi/constant/matter_type.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/pages/matter_templates/page.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplateArea extends StatelessWidget {
  const TemplateArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<AddPageStore>(context);
    final name = formStore.name ?? '';
    final time = formStore.datetime;
    final type = formStore.type ?? MatterTypes.newBuild;

    final color = Color(formStore.color);
    final fontColor = Color(formStore.fontColor);

    return OpenContainer(
        openBuilder: (context, action) => const MatterTemplatesPage(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionType: ContainerTransitionType.fadeThrough,
        closedElevation: 0,
        closedColor: surfaceColor,
        closedBuilder: (context, action) => Matter(
              fontColor: fontColor,
              color: color,
              time: time,
              type: type,
              name: name,
            ));
  }
}
