part of 'user_management_bloc.dart';

@freezed
class UserManagementState with _$UserManagementState {
  const factory UserManagementState.initial() = Initial;
  const factory UserManagementState.loading() = Loading;
  const factory UserManagementState.loaded({
    @Default([]) List<User> users,
    User? user,
    String? message,
  }) = Loaded;
  const factory UserManagementState.error(String message) = Error;

  const UserManagementState._();

  List<User> get users => mapOrNull(loaded: (state) => state.users) ?? [];

  User? get user => mapOrNull(loaded: (state) => state.user);

  String? get message => mapOrNull(loaded: (state) => state.message);
}
