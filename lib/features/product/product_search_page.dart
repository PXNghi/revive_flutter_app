import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/product_item_list.dart';
import 'package:revive_flutter_project/features/product/bloc/product/product_bloc.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: MyIconButton(
              icon: arrowLeftIcon,
              onTap: () => Navigator.of(context).pop(),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm',
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide:
                        const BorderSide(color: grayBorderColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide:
                        const BorderSide(color: primaryColor, width: 1.0),
                  ),
                ),
                onChanged: (value) {
                  context.read<ProductBloc>().add(ProductEvent.getAllProducts(search: value));
                },
              ),
            ),
          ),
          body: Padding(
            padding: pageHorizontalPadding,
            child: Column(
              children: [
                Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.0),
                      itemCount: state.products?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ProductItemList(
                              productName: state.products?[index].name ?? "",
                              productCategory:
                                  state.products?[index].category.name ?? "",
                              productPrice: state.products?[index].price ?? 0,
                              productImage: state.products?[index].image ?? userDefaultImage,
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
                                                  state.products?[index].name ?? "",
                                                  true,
                                                  state.products?[index].id ?? "",
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
                                          // _showProductDialog(
                                          //   isEdit: true,
                                          //   context,
                                          //   productId: state.products[index].id,
                                          //   productName:
                                          //       state.products[index].name,
                                          //   productPrice: state
                                          //       .products[index].price
                                          //       .toString(),
                                          //   productDetails: state
                                          //       .products[index].description,
                                          //   categoryId: state
                                          //       .products[index].category.id,
                                          //   productImage:
                                          //       state.products[index].image,
                                          // );
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
              ],
            ),
          ),
        );
      },
    );
  }
}
