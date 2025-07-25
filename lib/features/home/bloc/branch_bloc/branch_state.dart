part of 'branch_bloc.dart';

@freezed
class BranchState with _$BranchState {
  const factory BranchState.initial() = _Initial;
  const factory BranchState.loading() = _Loading;
  const factory BranchState.loaded({
    @Default([]) List<Branch> branches,
    Branch? selectedBranch,
  }) = _Loaded;
  const factory BranchState.error(String message) = _Error;

  const BranchState._();

  List<Branch> get branches => mapOrNull(loaded: (value) => value.branches) ?? [];

  Branch? get selectedBranch => mapOrNull(loaded: (value) => value.selectedBranch);
}
