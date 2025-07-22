part of 'forget_password_bloc.dart';

@freezed
class ForgetPasswordState with _$ForgetPasswordState {
  const factory ForgetPasswordState.forgetInitial({
    String? emailError,
    String? otpError,
    String? passwordError,
    String? confirmPasswordError,
  }) = ForgetInitial;

  const factory ForgetPasswordState.forgetLoading() = ForgetLoading;
  const factory ForgetPasswordState.sendOTPSuccess() = SendOTPSuccess;
  const factory ForgetPasswordState.forgetSuccess() = ForgetSuccess;
  const factory ForgetPasswordState.resetPasswordSuccess() = ResetPasswordSuccess;
  const factory ForgetPasswordState.forgetError(String message) = ForgetError;

  const ForgetPasswordState._();

  String? get emailError => mapOrNull(forgetInitial: (value) => value.emailError);

  String? get otpError => mapOrNull(forgetInitial: (value) => value.otpError);

  String? get passwordError => mapOrNull(forgetInitial: (value) => value.passwordError);

  String? get confirmPasswordError => mapOrNull(forgetInitial: (value) => value.confirmPasswordError);
}
