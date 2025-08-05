import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/order/models/order.dart';

part 'main_order_event.dart';
part 'main_order_state.dart';
part 'main_order_bloc.freezed.dart';

class MainOrderBloc extends Bloc<MainOrderEvent, MainOrderState> {
  MainOrderBloc() : super(const MainOrderState.initial()) {
    
  }
}
