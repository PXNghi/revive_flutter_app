import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/features/order/models/added_list_product.dart';
import 'package:revive_flutter_project/features/order/models/detailed_order_model.dart';
import 'package:revive_flutter_project/features/order/order_usecases.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';
import 'package:revive_flutter_project/features/product/model/product.dart';
import 'package:revive_flutter_project/features/product/product_usecases.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

enum PickUpOption { pickUp, comeBranch }

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderUsecases _orderUsecases = OrderUsecases();
  final ProductUsecase _productUsecase = ProductUsecase();
  File? imageFile;
  List<DetailedOrder> cartChosen = [];
  OrderBloc() : super(const OrderState.initial()) {
    on<_FetchAllCategory>(_handleFetchAllCategory);
    on<_FetchAllProductByCategory>(_handleFetchProductByCategoryId);
    on<_UploadProductImage>(_handleUploadProductImage);
    on<_DeleteProductImage>(_handleDeleteProductImage);
    on<_GetDisabledDates>(_handleGetDisableDates);
    on<_ChoosePickupOption>(_handleChoosePickupOption);
    on<_ChooseDatePickup>(_handleChooseDatePickup);
    on<_ValidateInformations>(_handleValidateInformations);
    on<_CreateOrder>(_handleCreateOrder);
    on<_AddProductToCart>(_handleAddProductToCart);
  }

  FutureOr<void> _handleFetchAllCategory(
    _FetchAllCategory event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderState.loading());
    final List<Category> categories = await _productUsecase.getAllCategories();
    emit(OrderState.loaded(categories: categories));
  }

  FutureOr<void> _handleFetchProductByCategoryId(
    _FetchAllProductByCategory event,
    Emitter<OrderState> emit,
  ) async {
    final List<Product> products =
        await _productUsecase.getAllProductsByCategory(event.categoryId);
    if (state is _Loaded) {
      final loadedState = state as _Loaded;
      emit(
        loadedState.copyWith(
          products: products,
        ),
      );
    }
  }

  FutureOr<void> _handleCreateOrder(
    _CreateOrder event,
    Emitter<OrderState> emit,
  ) async {}

  FutureOr<void> _handleValidateInformations(
    _ValidateInformations event,
    Emitter<OrderState> emit,
  ) async {
    if (state is _Loaded) {
      final loadedState = state as _Loaded;

      // emit(const OrderState.loading());
      try {
        String? nameError;
        String? phoneError;
        String? addressError;

        if (event.userName.isEmpty) {
          nameError = "Không được để trống";
        }

        if (event.userPhone.isEmpty) {
          phoneError = "Không được để trống";
        } else if (!phoneRegex.hasMatch(event.userPhone)) {
          phoneError = "Định dạng số điện thoại không đúng";
        }

        if (event.userAddress.isEmpty) {
          addressError = "Không được để trống";
        } else if (event.userAddress.length < 10) {
          addressError = "Địa chỉ không hợp lệ";
        }

        final isValid =
            nameError == null && phoneError == null && addressError == null;

        if (isValid) {
        } else {
          emit(
            loadedState.copyWith(
              userNameError: nameError,
              userPhoneError: phoneError,
              userAddressError: addressError,
            ),
          );
        }
      } catch (e) {
        print("Error validating informations: $e");
      }
    }
  }

  FutureOr<void> _handleUploadProductImage(
    _UploadProductImage event,
    Emitter<OrderState> emit,
  ) async {
    try {
      if (state is _Loaded) {
        final loadedState = state as _Loaded;
        final result =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (result != null) {
          imageFile = File(result.path);
          emit(loadedState.copyWith(imageFile: imageFile));
        }
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  FutureOr<void> _handleDeleteProductImage(
    _DeleteProductImage event,
    Emitter<OrderState> emit,
  ) async {
    try {
      if (state is _Loaded) {
        final loadedState = state as _Loaded;
        emit(loadedState.copyWith(imageFile: null));
      }
    } catch (e) {
      print("Error deleting image: $e");
    }
  }

  FutureOr<void> _handleAddProductToCart(
    _AddProductToCart event,
    Emitter<OrderState> emit,
  ) async {
    try {
      if (state is _Loaded) {
        final loadedState = state as _Loaded;

        final updatedCart = List<DetailedOrder>.from(loadedState.cart)
          ..add(event.detailedOrder);

        final product = loadedState.products.firstWhereOrNull(
          (p) => p.id == event.detailedOrder.productId,
        );

        final category = loadedState.categories.firstWhereOrNull(
          (c) => c.id == product?.category.id,
        );

        final addedProduct = AddedListProduct(
          detailedOrder: event.detailedOrder,
          productName: product?.name ?? "",
          categoryName: category?.name ?? "",
        );

        final updatedAddedList =
            List<AddedListProduct>.from(loadedState.addedListProduct)
              ..add(addedProduct);

        emit(loadedState.copyWith(
          cart: updatedCart,
          addedListProduct: updatedAddedList,
        ));
      }
    } catch (e) {
      print("Error adding product to cart: $e");
    }
  }

  FutureOr<void> _handleChoosePickupOption(
    _ChoosePickupOption event,
    Emitter<OrderState> emit,
  ) async {
    if (state is _Loaded) {
      final loadedState = state as _Loaded;
      if (event.pick == PickUpOption.pickUp) {
        add(OrderEvent.getDisabledDates(DateFormat('yyyy-MM').format(DateTime.now())));
      }
      emit(loadedState.copyWith(selectedPickUpOption: event.pick));
    }
  }

  FutureOr<void> _handleChooseDatePickup(
    _ChooseDatePickup event,
    Emitter<OrderState> emit,
  ) async {
    if (state is _Loaded) {
      final loadedState = state as _Loaded;
    }
  }

  FutureOr<void> _handleGetDisableDates(
    _GetDisabledDates event,
    Emitter<OrderState> emit,
  ) async {
    if (state is _Loaded) {
      final loadedState = state as _Loaded;
      emit(const OrderState.loading());
      final List<DateTime> disabledDates = await _orderUsecases.getDisabledDates(event.month);
      emit(loadedState.copyWith(disabledDates: disabledDates));
    }
  }
}
