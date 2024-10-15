import 'dart:math';

import 'package:expenses_tracker/business_logic/category_bloc/category_bloc.dart';
import 'package:expenses_tracker/presentation/add_expense/widgets/category_creation_show_dialog.dart';
import 'package:expenses_tracker/presentation/widgets/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/models/models.dart';

FormField<Object> categoryFormField(
    {required BuildContext context,
    required Map<String, String> categoriesIcons,
    required Expense expense,
    required Function(Category category) onCategorySelected,
    required final AnimationController controller,
    required bool isEditing,
    required Function(Category category) onRemoveCategory,
    required GestureLongPressCallback? toggleEditing}) {
  return FormField(
    validator: (value) {
      if (expense.category.name == '') {
        return 'Please select a category';
      }
      return null;
    },
    builder: (fieldState) => GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        if (isEditing) {
          toggleEditing!();
        }
      },
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is GetCategoriesSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 320,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceBright,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length + 1,
                      itemBuilder: ((context, int i) {
                        if (i == 0) {
                          return GestureDetector(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (ctx) => CategoryCreation(
                                        categoriesIcons: categoriesIcons,
                                        context: context,
                                      ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(children: [
                                const Text(
                                  'Add category',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Card(
                                  color: Colors.green[300],
                                  shape: const CircleBorder(),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        FontAwesomeIcons.plus,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceBright,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          );
                        }

                        var category = state.categories[i - 1];

                        return GestureDetector(
                          onLongPress: toggleEditing,
                          onTap: () {
                            onCategorySelected(category);
                          },
                          child: Stack(
                            children: [
                              AnimatedBuilder(
                                animation: controller,
                                builder: (context, child) {
                                  if (isEditing) {
                                    return Transform.rotate(
                                      angle:
                                          0.02 * sin(controller.value * 2 * pi),
                                      child: child,
                                    );
                                  } else {
                                    return child!;
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (category == expense.category
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                            : Theme.of(context)
                                                .colorScheme
                                                .surfaceBright)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(children: [
                                    Text(
                                      category.name.toString(),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Card(
                                      color: Color(category.color),
                                      shape: const CircleBorder(),
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SvgPicture.asset(
                                            categoriesIcons[category.icon] ??
                                                '',
                                            colorFilter: ColorFilter.mode(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .surfaceBright,
                                                BlendMode.srcIn),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              isEditing
                                  ? Positioned(
                                      top: 3,
                                      right: 3,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final wantRemove =
                                              await showConfirmDialog(
                                                  context: context,
                                                  title: 'Remove category',
                                                  content:
                                                      'Are you sure you want to remove this category?',
                                                  firstAction: 'Cancel',
                                                  secondAction: 'Remove');
                                          if (wantRemove && context.mounted) {
                                            onRemoveCategory(category);
                                          }
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        );
                      }),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                    ),
                  ),
                ),
                if (fieldState.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      fieldState.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ),
  );
}
