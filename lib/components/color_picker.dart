import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 用于弹窗，需要Stateful
class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.onFinish,
  });

  final Function(int color) onFinish;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    Color? selectedColor;
    return standardContainer(
      context: context,
      child: IntrinsicHeight(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: topContainerColor(context),
                  borderRadius: const BorderRadius.all(Radius.circular(16))),
              height: 256,
              child: MaterialColorPicker(onColorChange: (Color color) {
                selectedColor = color;
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  SmartDialog.dismiss();
                  if (selectedColor != null) {
                    widget.onFinish(selectedColor!.value);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: middleContainerColor(context)),
                child:
                    Text("更新", style: TextStyle(color: primaryColor(context))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
