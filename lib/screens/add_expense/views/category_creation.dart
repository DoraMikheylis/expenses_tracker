import 'package:expenses_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/screens/add_expense/views/add_expense_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> categoryCreation(
    BuildContext context, Map<String, String> categoriesIcons) async {
  return await showDialog(
    context: context,
    builder: (ctx) {
      bool isExpended = false;
      String categoryIconSelected = '';
      Color categoryColorSelected = Colors.white;

      TextEditingController categoryNameController = TextEditingController();

      return StatefulBuilder(
        builder: (ctx, setState) {
          return BlocConsumer<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {}
                if (state is CreateCategoryFailure) {}
              },
              builder: (context, state) => AlertDialog(
                    actions: [
                      state is CreateCategoryLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SaveButton(
                              label: 'Save category',
                              onPressed: () {
                                createCategory(
                                    context: context,
                                    categoryName: categoryNameController.text,
                                    categoryIcon: categoryIconSelected,
                                    categoryColor: categoryColorSelected.value);
                                context
                                    .read<GetCategoriesBloc>()
                                    .add(const GetCategories());
                              }),
                    ],
                    title: const Text('Create a new category'),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: categoryNameController,
                            onTap: () {},
                            decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none)),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            onTap: () {
                              setState(() {
                                isExpended = !isExpended;
                              });
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                                suffixIcon:
                                    const Icon(CupertinoIcons.chevron_down),
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Icon',
                                border: OutlineInputBorder(
                                    borderRadius: isExpended
                                        ? const BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          )
                                        : BorderRadius.circular(12),
                                    borderSide: BorderSide.none)),
                          ),
                          isExpended
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12),
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
                                              setState(() {
                                                categoryIconSelected =
                                                    categoriesIcons.keys
                                                        .elementAt(i);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 2,
                                                    color:
                                                        categoryIconSelected ==
                                                                categoriesIcons
                                                                    .keys
                                                                    .elementAt(
                                                                        i)
                                                            ? Colors.green
                                                            : Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: SvgPicture.asset(
                                                  categoriesIcons.values
                                                      .elementAt(i),
                                                  colorFilter:
                                                      categoryIconSelected ==
                                                              categoriesIcons
                                                                  .keys
                                                                  .elementAt(i)
                                                          ? const ColorFilter
                                                              .mode(
                                                              Colors.green,
                                                              BlendMode.srcIn)
                                                          : const ColorFilter
                                                              .mode(Colors.grey,
                                                              BlendMode.srcIn),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx2) {
                                  return AlertDialog(
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: const [
                                      SaveButton(
                                        label: 'Save color',
                                      ),
                                    ],
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ColorPicker(
                                          pickerColor: categoryColorSelected,
                                          onColorChanged: (color) {
                                            setState(
                                              () {
                                                categoryColorSelected = color;
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: categoryColorSelected,
                                hintText: 'Color',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none)),
                          ),
                        ],
                      ),
                    ),
                  ));
        },
      );
    },
  );
}
