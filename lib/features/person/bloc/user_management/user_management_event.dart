part of 'user_management_bloc.dart';

@freezed
class UserManagementEvent with _$UserManagementEvent {
  const factory UserManagementEvent.started() = _Started;
  const factory UserManagementEvent.getAllUsers() = _GetAllUsers;
  const factory UserManagementEvent.activateUser(String userId) = _ActivateUser;
  const factory UserManagementEvent.deactivateUser(String userId) =
      _DeactivateUser;
  const factory UserManagementEvent.getUserById(String userId) = _GetUserById;
  const factory UserManagementEvent.updateUserProfileById(
    String userId,
    String userName,
    String userPhone,
    String address,
  ) = _UpdateUserProfileById;
  const factory UserManagementEvent.toggleAddressField(bool isToggleAddress) = _ToggleAddressField;
}
