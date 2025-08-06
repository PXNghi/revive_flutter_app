import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/features/order/models/added_list_product.dart';
import 'package:revive_flutter_project/features/order/models/order.dart';
import 'package:revive_flutter_project/features/order/order_usecases.dart';
import 'package:revive_flutter_project/features/product/model/category.dart';
import 'package:revive_flutter_project/features/product/model/product.dart';
import 'package:revive_flutter_project/features/product/product_usecases.dart';

part 'main_order_event.dart';
part 'main_order_state.dart';
part 'main_order_bloc.freezed.dart';

enum OrderStatus {
  waiting,
  confirmed,
  completed,
  cancelled,
  delivering,
}

class MainOrderBloc extends Bloc<MainOrderEvent, MainOrderState> {
  final OrderUsecases _orderUsecases = OrderUsecases();
  final ProductUsecase _productUsecase = ProductUsecase();
  late String role;
  List<Product> products = [];
  List<Category> categories = [];
  MainOrderBloc() : super(const MainOrderState.initial()) {
    on<_Started>(_handleStarted);
    on<_ChangeTab>(_handleChangeTabs);
  }

  FutureOr<void> _handleStarted(
    _Started event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      emit(const MainOrderState.loading(selectedIndex: 0));
      role = SessionData.mine?.role ?? "User";
      products = await _productUsecase.getAllProducts();
      categories = await _productUsecase.getAllCategories();
      List<Order> waitingOrders = await getAllOrdersByRole(role, OrderStatus.waiting.name);

      emit(MainOrderState.loaded(orders: waitingOrders));
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  FutureOr<void> _handleChangeTabs(
    _ChangeTab event,
    Emitter<MainOrderState> emit,
  ) async {
    final OrderStatus selectedStatus = OrderStatus.values[event.tabIndex];
    try {
      switch (selectedStatus) {
        case OrderStatus.waiting:
          emit(const MainOrderState.loading(selectedIndex: 0));
          final List<Order> waitingOrders =
              await getAllOrdersByRole(role, OrderStatus.waiting.name);
          emit(MainOrderState.loaded(orders: waitingOrders, selectedIndex: 0));
        case OrderStatus.confirmed:
          emit(const MainOrderState.loading(selectedIndex: 1));
          final List<Order> confirmedOrders =
              await getAllOrdersByRole(role, OrderStatus.confirmed.name);
          emit(
              MainOrderState.loaded(orders: confirmedOrders, selectedIndex: 1));
        case OrderStatus.completed:
          emit(const MainOrderState.loading(selectedIndex: 2));
          final List<Order> completedOrders =
              await getAllOrdersByRole(role, OrderStatus.completed.name);
          emit(
              MainOrderState.loaded(orders: completedOrders, selectedIndex: 2));
        case OrderStatus.cancelled:
          emit(const MainOrderState.loading(selectedIndex: 3));
          final List<Order> cancelledOrders =
              await getAllOrdersByRole(role, OrderStatus.cancelled.name);
          emit(
              MainOrderState.loaded(orders: cancelledOrders, selectedIndex: 3));
        default:
          emit(const MainOrderState.loading(selectedIndex: 0));
          final List<Order> waitingOrders =
              await getAllOrdersByRole(role, OrderStatus.waiting.name);
          emit(MainOrderState.loaded(orders: waitingOrders));
      }
    } catch (e) {
      print("Error change tabs: $e");
    }
  }

  Future<List<Order>> getAllOrdersByRole(String role, String status) async {
    List<Order> orders = [];
    if (role == "User") {
      orders = await _orderUsecases.getAllMyOrders(status);
    } else {
      orders = await _orderUsecases.getAllOrdersAdmin(status);
    }
    return orders;
  }
}
