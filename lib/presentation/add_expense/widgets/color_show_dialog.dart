import 'package:expenses_tracker/constants/colors_for_color_picker.dart';
import 'package:expenses_tracker/presentation/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<void> colorShowDialog(BuildContext context,
    ValueChanged<Color> onSelected, Color categoryColorSelected) async {
  return await showDialog(
    context: context,
    builder: (ctxColor) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          SaveButton(
              label: 'Save color',
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            SizedBox(
              height: 375,
              child: BlockPicker(
                availableColors: colorPickerColors,
                pickerColor: categoryColorSelected,
                onColorChanged: onSelected,
              ),
            ),
          ]),
        ),
      );
    },
  );
}
