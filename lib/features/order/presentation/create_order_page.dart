import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_flutter_project/core/configs/apis/my_enviroment.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/constants/ui_values.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/widgets/expand_product_board.dart';
import 'package:revive_flutter_project/core/widgets/my_appbar.dart';
import 'package:revive_flutter_project/core/widgets/my_button.dart';
import 'package:revive_flutter_project/core/widgets/my_icon_button.dart';
import 'package:revive_flutter_project/core/widgets/my_text_button.dart';
import 'package:revive_flutter_project/core/widgets/my_textfield.dart';
import 'package:revive_flutter_project/core/widgets/order_product_item.dart';
import 'package:revive_flutter_project/features/order/bloc/order_bloc/order_bloc.dart';
import 'package:revive_flutter_project/features/order/models/detailed_order_model.dart';
import 'package:revive_flutter_project/features/person/models/user.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final User? currentUser = SessionData.mine;
  final String currentUserAddress =
      SessionData.currentUserAddress?.address ?? "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = currentUser?.name ?? '';
    _phoneController.text = currentUser?.phone ?? '';
    _addressController.text = currentUserAddress;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        print("cart: ${state.cart}");
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const MyAppbar(
            title: "",
            isLeadingImplied: true,
          ),
          body: Padding(
            padding: pageHorizontalPadding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TẠO ĐƠN HÀNG",
                    style: headerStyle,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "THÔNG TIN CÁ NHÂN",
                    style: titleStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    label: "Họ và tên",
                    controller: _nameController,
                    errorText: state.userNameError,
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    label: "Số điện thoại",
                    controller: _phoneController,
                    errorText: state.userPhoneError,
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    label: "Địa chỉ",
                    controller: _addressController,
                    errorText: state.userAddressError,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "THÔNG TIN VẬT PHẨM",
                    style: titleStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: MyButton(
                      onTap: () {
                        _showProductDialog(context);
                      },
                      label: "Thêm vật phẩm",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Visibility(
                    visible: state.cart?.isNotEmpty ?? false,
                    child: ExpandProduct(
                      cart: state.addedListProduct
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "CÁCH THU GOM",
                    style: titleStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 16.0),

                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffD1D1D6).withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: MyButton(
                label: "Tiếp theo",
                onTap: () {
                  context.read<OrderBloc>().add(
                        OrderEvent.validateInformations(
                          userName: _nameController.text,
                          userPhone: _phoneController.text,
                          userAddress: _addressController.text,
                          products: [],
                          pickUpOption: "",
                        ),
                      );
                },
                width: 130,
                height: 40,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProductDialog(
    BuildContext context, {
    String? productId,
    String? categoryId,
    String? productImage,
    bool isEdit = false,
  }) async {
    final bloc = context.read<OrderBloc>();
    final TextEditingController productAmountController =
        TextEditingController();
    final TextEditingController productNoteController = TextEditingController();
    String selectedCategoryId = "";
    String selectedProductId = "";
    bool isValid = true;
    await showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Builder(builder: (context) {
            return BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {},
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
                        BlocBuilder<OrderBloc, OrderState>(
                          builder: (context, state) {
                            return Padding(
                              padding: pageHorizontalPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Chọn danh mục",
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
                                      context.read<OrderBloc>().add(
                                            OrderEvent
                                                .fetchAllProductByCategory(
                                              selectedCategoryId,
                                            ),
                                          );
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Chọn sản phẩm",
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
                                    value: productId,
                                    items: state.products != null
                                        ? state.products!
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.id,
                                                child: Text(e.name),
                                              ),
                                            )
                                            .toList()
                                        : [],
                                    onChanged: (value) {
                                      selectedProductId = value.toString();
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  MyTextField(
                                    controller: productAmountController,
                                    label: "Nhập số lượng",
                                  ),
                                  const SizedBox(height: 10.0),
                                  MyTextField(
                                    controller: productNoteController,
                                    label: "Ghi chú",
                                    maxLines: 3,
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
                                      state.imageFile != null
                                          ? buildImageWidget(
                                              isEdit: false,
                                              imageWidget: Image.file(
                                                state.imageFile!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(Icons.error),
                                              ),
                                              onDelete: () {
                                                context.read<OrderBloc>().add(
                                                    const OrderEvent
                                                        .deleteProductImage());
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
                                                    context
                                                        .read<OrderBloc>()
                                                        .add(const OrderEvent
                                                            .deleteProductImage());
                                                  },
                                                )
                                              : MyTextButton(
                                                  text: 'Thêm hình ảnh',
                                                  onTap: () {
                                                    context
                                                        .read<OrderBloc>()
                                                        .add(const OrderEvent
                                                            .uploadProductImage());
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
                                        } else {
                                          if (selectedProductId == "" ||
                                              selectedCategoryId == "") {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      side: const BorderSide(
                                                        color: primaryColor,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    insetPadding:
                                                        pageHorizontalPadding,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const SizedBox(
                                                            height: 10.0),
                                                        const Text(
                                                          "THÔNG BÁO",
                                                          style: headerStyle,
                                                        ),
                                                        const SizedBox(
                                                            height: 20.0),
                                                        const Padding(
                                                          padding:
                                                              pageHorizontalPadding,
                                                          child: Text(
                                                              "Vui lòng chọn danh mục và sản phẩm tương ứng!"),
                                                        ),
                                                        const SizedBox(
                                                            height: 20.0),
                                                        MyButton(
                                                          label: "OK",
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            height: 10.0),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          } else {
                                            final DetailedOrder newOrder =
                                                DetailedOrder(
                                              productId: selectedProductId,
                                              productNote:
                                                  productNoteController.text,
                                              amount: double.parse(
                                                  productAmountController.text),
                                              image:
                                                  state.imageFile?.path ?? "",
                                            );
                                            context.read<OrderBloc>().add(
                                                OrderEvent.addProductToCart(
                                                    newOrder, ));
                                            Navigator.pop(context);
                                          }
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
