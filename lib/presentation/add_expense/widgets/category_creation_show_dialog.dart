import 'package:expenses_tracker/business_logic/category_bloc/category_bloc.dart';
import 'package:expenses_tracker/presentation/add_expense/widgets/color_show_dialog.dart';
import 'package:expenses_tracker/presentation/add_expense/widgets/create_category.dart';
import 'package:expenses_tracker/presentation/add_expense/widgets/icon_show_dialog.dart';
import 'package:expenses_tracker/presentation/widgets/save_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCreation extends StatefulWidget {
  final Map<String, String> categoriesIcons;
  final BuildContext context;

  const CategoryCreation(
      {super.key, required this.categoriesIcons, required this.context});

  @override
  State<CategoryCreation> createState() => _CategoryCreationState();
}

class _CategoryCreationState extends State<CategoryCreation> {
  final _formKey = GlobalKey<FormState>();

  bool isExpended = false;
  String categoryIconSelected = '';
  Color categoryColorSelected = Colors.white;
  late Map<String, String> categoriesIcons;
  late BuildContext ctx;

  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    categoriesIcons = widget.categoriesIcons;
    ctx = widget.context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CategoryBloc>(ctx),
      child: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CreateCategorySuccess) {
              Navigator.of(context).pop();

              context.read<CategoryBloc>().add(const GetCategoriesEvent());
            }
            if (state is CreateCategoryFailure) {}
          },
          builder: (context, state) => Form(
                key: _formKey,
                child: AlertDialog(
                  actions: [
                    SaveButton(
                        label: 'Save category',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            createCategory(
                                context: context,
                                categoryName: categoryNameController.text,
                                categoryIcon: categoryIconSelected,
                                categoryColor: categoryColorSelected.value);
                          }
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name of category';
                            }
                            return null;
                          },
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
                          validator: (value) {
                            if (categoryIconSelected == '') {
                              return 'Please select an icon';
                            }
                            return null;
                          },
                          onTap: () async {
                            await iconShowDialog(
                                context, categoriesIcons, categoryIconSelected,
                                (icon) {
                              setState(() {
                                categoryIconSelected = icon;
                              });
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
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none)),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (categoryColorSelected == Colors.white) {
                              return 'Please select a color';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () async {
                            await colorShowDialog(context, (color) {
                              setState(
                                () {
                                  categoryColorSelected = color;
                                },
                              );
                            }, categoryColorSelected);
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
                ),
              )),
    );
  }
}
