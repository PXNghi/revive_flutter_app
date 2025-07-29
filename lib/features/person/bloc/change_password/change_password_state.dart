part of 'change_password_bloc.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState.initial() = Initial;
  const factory ChangePasswordState.loading() = Loading;
  const factory ChangePasswordState.validateFailed({
    String? oldPasswordError,
    String? newPasswordError,
    String? confirmedPasswordError,
  }) = ValidateFailed;
  const factory ChangePasswordState.success(String successMessage) = Success;
  const factory ChangePasswordState.error(String message) = Error;

  const ChangePasswordState._();

  String? get oldPasswordError => mapOrNull(validateFailed: (value) => value.oldPasswordError);

  String? get newPasswordError => mapOrNull(validateFailed: (value) => value.newPasswordError);

  String? get confirmedPasswordError => mapOrNull(validateFailed: (value) => value.confirmedPasswordError);

  String get successMessage =>
      mapOrNull(success: (value) => value.successMessage) ?? '';

  String get errorMessage => mapOrNull(error: (value) => value.message) ?? '';
}
