import 'package:expenses_tracker/presentation/widgets/save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Future<void> iconShowDialog(
    BuildContext context,
    Map<String, String> categoriesIcons,
    String categoryIconSelected,
    ValueChanged<String> onChanged) async {
  return await showDialog(
    context: context,
    builder: (ctxIcon) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              SaveButton(
                  label: 'Save icon',
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: 305,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: categoriesIcons.length,
                    itemBuilder: (context, int i) {
                      return GestureDetector(
                        onTap: () {
                          onChanged(categoriesIcons.keys.elementAt(i));
                          setState(() {
                            categoryIconSelected =
                                categoriesIcons.keys.elementAt(i);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: categoryIconSelected ==
                                        categoriesIcons.keys.elementAt(i)
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SvgPicture.asset(
                              categoriesIcons.values.elementAt(i),
                              colorFilter: categoryIconSelected ==
                                      categoriesIcons.keys.elementAt(i)
                                  ? ColorFilter.mode(
                                      Theme.of(context).colorScheme.tertiary,
                                      BlendMode.srcIn)
                                  : ColorFilter.mode(
                                      Theme.of(context).colorScheme.outline,
                                      BlendMode.srcIn),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )),
      );
    },
  );
}
