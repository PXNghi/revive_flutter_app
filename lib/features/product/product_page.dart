import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/category_item_list.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_text_button.dart';
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
          child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state.warningMessage != null) {
                _buildDeleteDialog(context);
              }

              if (state is ProductDeleted) {
                context.read<ProductBloc>().add(
                      const ProductEvent.fetchAllCategoriesAndProducts(),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Xóa sản phẩm thành công!"),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return Row(
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
                      Visibility(
                        visible: SessionData.mine?.role == "Admin",
                        child: MyIconButton(
                          icon: state.isEditingMode ? checkMarkIcon : editIcon,
                          size: 30,
                          onTap: () {
                            context.read<ProductBloc>().add(
                                  const ProductEvent.toggleEditingMode(),
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      MyIconButton(
                        icon: searchIcon,
                        size: 30,
                        onTap: () {},
                      ),
                    ],
                  );
                },
              ),
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
                    mainAxisSize: MainAxisSize.max,
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
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CategoryItemList(
                                  category: state.categories[index],
                                  isSelected:
                                      state.selectedCategoryIndex == index,
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
                                ),
                                Visibility(
                                  child: state.isEditingMode
                                      ? Positioned(
                                          right: -5,
                                          top: -3,
                                          child: MyIconButton(
                                            icon: deleteIcon,
                                            size: 24,
                                            isCircleIcon: false,
                                            onTap: () {
                                              context.read<ProductBloc>().add(
                                                    ProductEvent.warningDelete(
                                                      state.categories[index]
                                                          .name,
                                                      false,
                                                      "",
                                                      state
                                                          .categories[index].id,
                                                    ),
                                                  );
                                            },
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                Visibility(
                                  child: state.isEditingMode
                                      ? Positioned(
                                          left: -5,
                                          top: -3,
                                          child: MyIconButton(
                                            icon: editIcon,
                                            size: 24,
                                            isCircleIcon: false,
                                            onTap: () {
                                              _showCategoryDialog(
                                                context,
                                                categoryId:
                                                    state.categories[index].id,
                                                categoryName: state
                                                    .categories[index].name,
                                                categoryImage: state
                                                    .categories[index].image,
                                                isEdit: true,
                                              );
                                            },
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
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
                return const CircularProgressIndicator();
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.0),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ProductItemList(
                              productName: state.products[index].name,
                              productCategory:
                                  state.products[index].category.name,
                              productPrice: state.products[index].price,
                              productImage: state.products[index].image,
                            ),
                            Visibility(
                              child: state.isEditingMode
                                  ? Positioned(
                                      right: 10,
                                      top: 10,
                                      child: MyIconButton(
                                        icon: deleteIcon,
                                        size: 24,
                                        isCircleIcon: false,
                                        onTap: () {
                                          context.read<ProductBloc>().add(
                                                ProductEvent.warningDelete(
                                                  state.products[index].name,
                                                  true,
                                                  state.products[index].id,
                                                  "",
                                                ),
                                              );
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Visibility(
                              child: state.isEditingMode
                                  ? Positioned(
                                      right: 40,
                                      top: 10,
                                      child: MyIconButton(
                                        icon: editIcon,
                                        size: 24,
                                        isCircleIcon: false,
                                        onTap: () {
                                          _showProductDialog(
                                            isEdit: true,
                                            context,
                                            productId: state.products[index].id,
                                            productName:
                                                state.products[index].name,
                                            productPrice: state
                                                .products[index].price
                                                .toString(),
                                            productDetails: state
                                                .products[index].description,
                                            categoryId: state
                                                .products[index].category.id,
                                            productImage:
                                                state.products[index].image,
                                          );
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
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

  void _buildDeleteDialog(BuildContext context) {
    final bloc = context.read<ProductBloc>();
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: Dialog(
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
              color: Colors.white,
            ),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                print(
                    "state delete category id: ${state.warningDeleteCategoryId}");
                return Column(
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
                        "CẢNH BÁO",
                        style: titleStyle.copyWith(
                          fontSize: 20,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Bạn có chắc chắn muốn xóa ${state.warningMessage} không?",
                      style: contentStyle.copyWith(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyButton(
                          width: 100.0,
                          label: "Hủy",
                          color: alertColor,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 16.0),
                        MyButton(
                          width: 100.0,
                          label: "Xác nhận",
                          onTap: () {
                            if (state.isDeleteProduct) {
                              context.read<ProductBloc>().add(
                                    ProductEvent.deleteProduct(
                                      state.warningDeleteProductId,
                                    ),
                                  );
                            } else {
                              context.read<ProductBloc>().add(
                                    ProductEvent.deleteCategory(
                                      state.warningDeleteCategoryId,
                                    ),
                                  );
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),
          ),
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
            _showCategoryDialog(context);
          },
        ),
        PopupMenuItem(
          value: 'manage-products',
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text('Thêm sản phẩm', style: contentStyle),
          ),
          onTap: () {
            _showProductDialog(context);
          },
        ),
      ],
    );
  }

  void _showCategoryDialog(
    BuildContext context, {
    String? categoryId,
    String? categoryName,
    String? categoryImage,
    bool isEdit = false,
  }) async {
    final TextEditingController categoryNameController =
        TextEditingController();
    final bloc = context.read<ProductBloc>();
    await showDialog(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextField(
                              label: "Nhập tên danh mục",
                              controller: categoryNameController,
                              initialValue: categoryName,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Image.asset(
                                  linkIcon,
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 4.0),
                                state.image != null
                                    ? buildImageWidget(
                                        isEdit: false,
                                        imageWidget: Image.file(
                                          state.image!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                        ),
                                        onDelete: () {
                                          bloc.add(
                                            const ProductEvent.deleteImage(),
                                          );
                                        },
                                      )
                                    : (categoryImage != "" &&
                                            categoryImage != null)
                                        ? buildImageWidget(
                                            isEdit: true,
                                            imageWidget: Image.network(
                                              "${Enviroment.baseUrl}$categoryImage",
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.error),
                                            ),
                                            onDelete: () {
                                              bloc.add(
                                                ProductEvent.editImage(
                                                  categoryImage,
                                                  "category",
                                                ),
                                              );
                                            },
                                          )
                                        : MyTextButton(
                                            text: 'Thêm hình ảnh',
                                            onTap: () {
                                              bloc.add(const ProductEvent
                                                  .uploadImage());
                                            },
                                          ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            Center(
                              child: MyButton(
                                label: state.isEditingMode
                                    ? "Sửa"
                                    : "Thêm danh mục",
                                onTap: () {
                                  if (isEdit) {
                                    bloc.add(
                                      ProductEvent.updateCategory(
                                        categoryId!,
                                        categoryNameController.text.isEmpty
                                            ? categoryName ?? ""
                                            : categoryNameController.text,
                                        newCategoryUrl: categoryImage,
                                      ),
                                    );
                                  } else {
                                    bloc.add(
                                      ProductEvent.createCategory(
                                        categoryNameController.text,
                                      ),
                                    );
                                  }
                                  Navigator.of(context).pop();
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
    bloc.add(const ProductEvent.deleteImage());
  }

  void _showProductDialog(
    BuildContext context, {
    String? productId,
    String? productName,
    String? productPrice,
    String? productDetails,
    String? categoryId,
    String? productImage,
    bool isEdit = false,
  }) async {
    final bloc = context.read<ProductBloc>();
    final TextEditingController productNameController = TextEditingController();
    final TextEditingController productPriceController =
        TextEditingController();
    final TextEditingController productDetailsController =
        TextEditingController();
    String selectedCategoryId = "";
    await showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Builder(builder: (context) {
            return BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductCreated) {
                  Navigator.pop(context);
                  context.read<ProductBloc>().add(
                        const ProductEvent.fetchAllCategoriesAndProducts(),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Thêm sản phẩm thành công!"),
                    ),
                  );
                }

                if (state is ProductUpdated) {
                  Navigator.pop(context);
                  context.read<ProductBloc>().add(
                        const ProductEvent.fetchAllCategoriesAndProducts(),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cập nhật sản phẩm thành công!"),
                    ),
                  );
                }
              },
              child: Dialog(
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
                                    value: categoryId,
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
                                    label: "Nhập tên sản phẩm",
                                    initialValue: productName,
                                  ),
                                  const SizedBox(height: 10.0),
                                  MyTextField(
                                    controller: productPriceController,
                                    label: "Nhập giá",
                                    initialValue: productPrice,
                                  ),
                                  const SizedBox(height: 10.0),
                                  MyTextField(
                                    controller: productDetailsController,
                                    label: "Nhập chi tiết sản phẩm",
                                    maxLines: 3,
                                    initialValue: productDetails,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Image.asset(
                                        linkIcon,
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 4.0),
                                      state.image != null
                                          ? buildImageWidget(
                                              isEdit: false,
                                              imageWidget: Image.file(
                                                state.image!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(Icons.error),
                                              ),
                                              onDelete: () {
                                                bloc.add(
                                                  const ProductEvent
                                                      .deleteImage(),
                                                );
                                              },
                                            )
                                          : (productImage != "" &&
                                                  productImage != null)
                                              ? buildImageWidget(
                                                  isEdit: true,
                                                  imageWidget: Image.network(
                                                    "${Enviroment.baseUrl}$productImage",
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                  onDelete: () {
                                                    bloc.add(
                                                      ProductEvent.editImage(
                                                        productImage,
                                                        "product",
                                                      ),
                                                    );
                                                  },
                                                )
                                              : MyTextButton(
                                                  text: 'Thêm hình ảnh',
                                                  onTap: () {
                                                    bloc.add(
                                                      const ProductEvent
                                                          .uploadImage(),
                                                    );
                                                  },
                                                ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  Center(
                                    child: MyButton(
                                      label: isEdit ? "Sửa" : "Thêm",
                                      onTap: () {
                                        if (isEdit) {
                                          print("image product: $productImage");
                                          context.read<ProductBloc>().add(
                                                ProductEvent.updateProduct(
                                                  id: productId!,
                                                  name: productNameController
                                                          .text.isNotEmpty
                                                      ? productNameController
                                                          .text
                                                      : productName ?? "",
                                                  price: double.tryParse(
                                                        productPriceController
                                                                .text.isNotEmpty
                                                            ? productPriceController
                                                                .text
                                                            : productPrice ??
                                                                "",
                                                      ) ??
                                                      0.0,
                                                  categoryId: selectedCategoryId
                                                          .isNotEmpty
                                                      ? selectedCategoryId
                                                      : categoryId ?? "",
                                                  description:
                                                      productDetailsController
                                                              .text.isNotEmpty
                                                          ? productDetailsController
                                                              .text
                                                          : productDetails ??
                                                              "",
                                                  image: productImage ?? "",
                                                ),
                                              );
                                        } else {
                                          context.read<ProductBloc>().add(
                                                ProductEvent.createProduct(
                                                  name: productNameController
                                                      .text,
                                                  price: double.tryParse(
                                                        productPriceController
                                                            .text,
                                                      ) ??
                                                      0.0,
                                                  categoryId:
                                                      selectedCategoryId,
                                                  description:
                                                      productDetailsController
                                                          .text,
                                                ),
                                              );
                                        }
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
              ),
            );
          }),
        );
      },
    );
    bloc.add(const ProductEvent.deleteImage());
  }

  Widget buildImageWidget({
    required Widget imageWidget,
    required VoidCallback onDelete,
    required bool isEdit,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: imageWidget,
        ),
        Positioned(
          top: -10,
          right: -10,
          child: !isEdit
              ? IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.close,
                    color: primaryColor,
                  ),
                )
              : MyIconButton(
                  icon: editIcon,
                  onTap: onDelete,
                ),
        ),
      ],
    );
  }
}
