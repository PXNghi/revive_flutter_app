import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/home/models/branch.dart';
import 'package:revive_flutter_project/features/home/usecases/branch_usecases.dart';

part 'branch_event.dart';
part 'branch_state.dart';
part 'branch_bloc.freezed.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchUsecases _branchUsecases = BranchUsecases();
  BranchBloc() : super(const BranchState.initial()) {
    on<_GetBranches>(_handleGetAllBranches);
    on<_GetBranchesNearby>(_handleGetBranchesNearby);
  }

  FutureOr<void> _handleGetAllBranches(
    _GetBranches event,
    Emitter<BranchState> emit,
  ) async {
    emit(const BranchState.loading());
    final List<Branch> branches = await _branchUsecases.getAllBranches();
    emit(BranchState.loaded(branches: branches));
  }

  FutureOr<void> _handleGetBranchesNearby(
    _GetBranchesNearby event,
    Emitter<BranchState> emit,
  ) async {
    emit(const BranchState.loading());
    final List<Branch> branches = await _branchUsecases.getBranchesNearby(event.lat, event.lon);
    emit(BranchState.loaded(branches: branches));
  }
}
