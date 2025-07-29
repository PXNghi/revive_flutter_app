part of 'change_password_bloc.dart';

@freezed
class ChangePasswordEvent with _$ChangePasswordEvent {
  const factory ChangePasswordEvent.changePassword(
    String oldPassword,
    String newPassword,
    String confirmedPassword,
  ) = _ChangePassword;
}
