part of 'branch_bloc.dart';

@freezed
class BranchEvent with _$BranchEvent {
  const factory BranchEvent.getBranches() = _GetBranches;
  const factory BranchEvent.getBranchById(int id) = _GetBranchById;
  const factory BranchEvent.createNewBranch(Branch branch) = _CreateNewBranch;
  const factory BranchEvent.updateBranch(String id) = _UpdateBranch;
  const factory BranchEvent.deleteBranch(String id) = _DeleteBranch;
}