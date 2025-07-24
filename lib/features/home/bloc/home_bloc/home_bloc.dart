import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/home/models/branch.dart';
import 'package:revive_flutter_project/features/home/usecases/branch_usecases.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BranchUsecases branchUsecases = BranchUsecases();
  HomeBloc() : super(const HomeState.initial()) {
    on<_LoadAllHomeData>(_handleLoadAllHomeData);
  }

  FutureOr<void> _handleLoadAllHomeData(
    _LoadAllHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.loading());
    final List<Branch> branches = await branchUsecases.getAllBranches();
    emit(HomeState.loaded(branches: branches));
  }
}
