import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/category_item_list.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/features/product/bloc/product_bloc.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Visibility(
                  visible: SessionData.mine?.role == "Admin",
                  child: GestureDetector(
                    onTapDown: (details) {
                      final offset = details.globalPosition;
                      _showAddProductMenu(context, offset);
                    },
                    child: const MyIconButton(
                      icon: addIcon,
                      size: 30,
                    ),
                  ),
                ),
                const Spacer(),
                MyIconButton(
                  icon: searchIcon,
                  size: 30,
                  onTap: () {},
                ),
                const SizedBox(width: 16.0),
                MyIconButton(
                  icon: filterIcon,
                  size: 30,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: pageHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              "BẢNG GIÁ",
              style: headerStyle,
            ),
            const SizedBox(height: 20.0),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is Loaded) {
                  String categoryName = "";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 85,
                        width: double.infinity,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 20.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            return CategoryItemList(
                              category: state.categories[index],
                              isSelected: state.selectedCategoryIndex == index,
                              onTap: () {
                                context.read<ProductBloc>().add(
                                      ProductEvent.selectCategory(index),
                                    );
                                categoryName = state.categories[index].name;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Các loại $categoryName",
                        style: titleStyle.copyWith(fontSize: 22),
                      ),
                    ],
                  );
                }
                return const CircularProgressIndicator(
                  color: primaryColor,
                );
              },
            ),
            const SizedBox(height: 20.0),
            // ProductItemList(),
          ],
        ),
      ),
    );
  }

  void _showAddProductMenu(BuildContext context, Offset offset) {
    final Size screenSize = MediaQuery.of(context).size;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + 15,
        offset.dy + 20,
        screenSize.width - offset.dx,
        screenSize.height - offset.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: const BorderSide(
          color: primaryColor,
          width: 1.0,
        ),
      ),
      color: Colors.white,
      items: [
        PopupMenuItem(
          value: 'add-product',
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Thêm danh mục',
              style: contentStyle,
            ),
          ),
          onTap: () {
            _showAddCategoryDialog(context);
          },
        ),
        PopupMenuItem(
          value: 'manage-products',
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text('Thêm sản phẩm', style: contentStyle),
          ),
          onTap: () {},
        ),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context) async {
    final TextEditingController categoryNameController =
        TextEditingController();
    final bloc = context.read<ProductBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Builder(builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: const BorderSide(
                  color: primaryColor,
                  width: 1.0,
                ),
              ),
              insetPadding: pageHorizontalPadding,
              child: Container(
                padding: pageHorizontalPadding,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: primaryColor),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        "Thêm danh mục".toUpperCase(),
                        style: titleStyle.copyWith(
                          fontSize: 20,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            MyTextField(
                              label: "Nhập tên danh mục",
                              controller: categoryNameController,
                            ),
                            const SizedBox(height: 24.0),
                            Center(
                              child: MyButton(
                                label: "Thêm danh mục",
                                onTap: () {
                                  if (categoryNameController.text.isNotEmpty) {
                                    context.read<ProductBloc>().add(
                                          ProductEvent.createCategory(
                                            categoryNameController.text,
                                          ),
                                        );
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
