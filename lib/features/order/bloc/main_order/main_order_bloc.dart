import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/features/order/models/order.dart';
import 'package:revive_flutter_project/features/order/order_usecases.dart';

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
  late String role;

  MainOrderBloc() : super(const MainOrderState.initial()) {
    on<_Started>(_handleStarted);
    on<_ChangeTab>(_handleChangeTabs);
    on<_CancelOrder>(_handleCancelOrder);
    on<_AcceptOrder>(_handleAcceptOrder);
    on<_RejectOrder>(_handleRejectOrder);
    on<_ClearInformations>(_handleClearInformations);
    on<_ChooseAnotherDate>(_handleChooseAnotherDate);
    on<_UpdateNewInformation>(_handleUpdateNewInformation);
    on<_GetStatuses>(_handleGetStatuses);
    on<_ChooseAnotherStatus>(_handleChooseAnotherStatus);
    on<_SearchOrder>(_handleSearchOrder);
    on<_RefreshPage>(_handleRefreshPage);
  }

  FutureOr<void> _handleStarted(
    _Started event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      emit(const MainOrderState.loading(selectedIndex: 0));
      role = SessionData.mine?.role ?? "User";
      List<Order> waitingOrders =
          await getAllOrdersByRole(role, OrderStatus.waiting.name);

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

  FutureOr<void> _handleCancelOrder(
    _CancelOrder event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      final isCancelSuccess = await _orderUsecases.cancelOrder(event.orderId);
      if (isCancelSuccess) {
        emit(const MainOrderState.success());
        emit(const MainOrderState.loading(selectedIndex: 3));
        final List<Order> cancelledOrders =
            await getAllOrdersByRole(role, OrderStatus.cancelled.name);
        emit(MainOrderState.loaded(orders: cancelledOrders, selectedIndex: 3));
      } else {
        print("Failed to cancel order");
      }
    } catch (e) {
      print("Error cancel order: $e");
    }
  }

  FutureOr<void> _handleRejectOrder(
    _RejectOrder event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      String? reasonError;
      if (state is Loaded) {
        final loadedState = state as Loaded;

        if (event.rejectReason.isEmpty) {
          reasonError = "Không được để trống";
        }
        if (reasonError == null) {
          final isSuccess = await _orderUsecases.updateOrderAdmin(
            event.orderId,
            status: OrderStatus.cancelled.name,
            adminNote: event.rejectReason,
          );
          if (isSuccess) {
            emit(const MainOrderState.success());
            emit(const MainOrderState.loading(selectedIndex: 3));
            final List<Order> cancelledOrders =
                await getAllOrdersByRole(role, OrderStatus.cancelled.name);
            emit(MainOrderState.loaded(
                orders: cancelledOrders, selectedIndex: 3));
          }
        } else {
          emit(loadedState.copyWith(reasonError: reasonError));
        }
      }
    } catch (e) {
      print("Error reject order: $e");
    }
  }

  FutureOr<void> _handleClearInformations(
    _ClearInformations event,
    Emitter<MainOrderState> emit,
  ) async {
    if (state is Loaded) {
      final loadedState = state as Loaded;
      emit(loadedState.copyWith(
        reasonError: null,
        selectedDate: null,
        selectedStatus: null,
      ));
    }
  }

  FutureOr<void> _handleAcceptOrder(
    _AcceptOrder event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      final bool isSuccess = await _orderUsecases.updateOrderAdmin(
        event.orderId,
        status: OrderStatus.confirmed.name,
      );
      if (isSuccess) {
        emit(const MainOrderState.success());
        emit(const MainOrderState.loading(selectedIndex: 1));
        final List<Order> confirmedOrders =
            await getAllOrdersByRole(role, OrderStatus.confirmed.name);
        emit(MainOrderState.loaded(orders: confirmedOrders, selectedIndex: 1));
      }
    } catch (e) {
      print("Error accept order: $e");
    }
  }

  FutureOr<void> _handleChooseAnotherDate(
    _ChooseAnotherDate event,
    Emitter<MainOrderState> emit,
  ) async {
    if (state is Loaded) {
      final loadedState = state as Loaded;
      emit(loadedState.copyWith(selectedDate: event.selectedDate));
    }
  }

  FutureOr<void> _handleUpdateNewInformation(
    _UpdateNewInformation event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      final bool isSuccess = await _orderUsecases.updateOrderAdmin(
        event.orderId,
        status: event.status,
        adminNote: event.adminNote,
        pickUpDate: event.orderDate,
        pickUpTimeStart: event.orderTimeStart,
        pickUpTimeEnd: event.orderTimeEnd,
        totalPrice: event.totalPrice,
      );
      if (isSuccess) {
        final Order? order = await _orderUsecases.getOrderById(event.orderId);
        if (order != null) {
          if (state is Loaded) {
            final loadedState = state as Loaded;
            emit(loadedState.copyWith(order: order));
          }
        }
      }
    } catch (e) {
      print("Error update new information: $e");
    }
  }

  FutureOr<void> _handleGetStatuses(
    _GetStatuses event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      if (state is Loaded) {
        final loadedState = state as Loaded;
        final List<String> statusList = [
          OrderStatus.waiting.name,
          OrderStatus.confirmed.name,
          OrderStatus.delivering.name,
          OrderStatus.completed.name,
          OrderStatus.cancelled.name
        ];
        // final List<String> availableStatuses = statusList
        //     .where((status) => status != event.currentStatus)
        //     .toList();
        // print("availableStatuses: $availableStatuses");
        emit(loadedState.copyWith(availableStatus: statusList));
      }
    } catch (e) {
      print("Error update status: $e");
    }
  }

  FutureOr<void> _handleChooseAnotherStatus(
    _ChooseAnotherStatus event,
    Emitter<MainOrderState> emit,
  ) async {
    if (state is Loaded) {
      final loadedState = state as Loaded;
      emit(loadedState.copyWith(selectedStatus: event.orderId));
    }
  }

  FutureOr<void> _handleSearchOrder(
    _SearchOrder event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      final List<Order> searchedOrders =
          await _orderUsecases.getAllOrders(search: event.search);
      emit(MainOrderState.loaded(orders: searchedOrders));
    } catch (e) {
      print("Error search order: $e");
    }
  }

  FutureOr<void> _handleRefreshPage(
    _RefreshPage event,
    Emitter<MainOrderState> emit,
  ) async {
    try {
      add(MainOrderEvent.changeTab(event.tabIndex));
    } catch (e) {
      print("Error refresh page: $e");
    }
  }
}
