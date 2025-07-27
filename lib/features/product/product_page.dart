import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/category_item_list.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/core/widgets/product_item_list.dart';
import 'package:revive_flutter_project/features/product/bloc/product/product_bloc.dart';

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
                  icon: editIcon,
                  size: 30,
                  onTap: () {},
                ),
                const SizedBox(width: 16.0),
                MyIconButton(
                  icon: searchIcon,
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
                                context.read<ProductBloc>().add(
                                      ProductEvent.getAllProductsByCategory(
                                        state.categories[index].id,
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      state.selectedCategoryIndex != -1
                          ? Text(
                              "Các loại ${state.categories[state.selectedCategoryIndex].name}",
                              style: titleStyle.copyWith(fontSize: 22),
                            )
                          : Text(
                              "Tất cả sản phẩm",
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
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is Loaded) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text(
                        "Không có sản phẩm nào trong danh mục này",
                        style: contentStyle,
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return ProductItemList(
                          productName: state.products[index].name,
                          productCategory: state.products[index].category.name,
                          productPrice: state.products[index].price,
                          productImage: state.products[index].image,
                        );
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductMenu(
    BuildContext context,
    Offset offset,
  ) {
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
          onTap: () {
            _showAddProductDialog(context);
          },
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

  void _showAddProductDialog(BuildContext context) {
    final bloc = context.read<ProductBloc>();
    final TextEditingController productNameController = TextEditingController();
    final TextEditingController productPriceController =
        TextEditingController();
    final TextEditingController productDetailsController =
        TextEditingController();
    String selectedCategoryId = "";
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
                child: SingleChildScrollView(
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
                          "Thêm sản phẩm".toUpperCase(),
                          style: titleStyle.copyWith(
                            fontSize: 20,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          if (state is ProductCreated) {
                            Navigator.of(context).pop();
                            context.read<ProductBloc>().add(
                                  const ProductEvent.fetchAllCategoriesAndProducts(),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Thêm sản phẩm thành công!"),
                              ),
                            );
                          }
                          return Padding(
                            padding: pageHorizontalPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Thêm danh mục",
                                  style: contentStyle.copyWith(
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                DropdownButtonFormField(
                                  dropdownColor: Colors.white,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: cardBorderRadius,
                                      borderSide: BorderSide(
                                        color: grayBorderColor,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: cardBorderRadius,
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  value: (state.categories!.isNotEmpty) && state.selectedCategoryIndex != -1
                                      ? state
                                          .categories![
                                              state.selectedCategoryIndex]
                                          .id
                                      : null,
                                  items: state.categories != null
                                      ? state.categories!
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.name),
                                            ),
                                          )
                                          .toList()
                                      : [],
                                  onChanged: (value) {
                                    selectedCategoryId = value.toString();
                                  },
                                ),
                                const SizedBox(height: 10.0),
                                MyTextField(
                                  controller: productNameController,
                                  label: "Nhập tên danh mục",
                                ),
                                const SizedBox(height: 10.0),
                                MyTextField(
                                  controller: productPriceController,
                                  label: "Nhập giá",
                                ),
                                const SizedBox(height: 10.0),
                                MyTextField(
                                  controller: productDetailsController,
                                  label: "Nhập chi tiết sản phẩm",
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 20.0),
                                Center(
                                  child: MyButton(
                                    label: "Thêm",
                                    onTap: () {
                                      context.read<ProductBloc>().add(
                                            ProductEvent.createProduct(
                                              name: productNameController.text,
                                              price: double.tryParse(
                                                    productPriceController.text,
                                                  ) ??
                                                  0.0,
                                              categoryId: selectedCategoryId,
                                              description:
                                                  productDetailsController.text,
                                              image: "",
                                            ),
                                          );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
