part of 'forget_password_bloc.dart';

@freezed
class ForgetPasswordEvent with _$ForgetPasswordEvent {
  const factory ForgetPasswordEvent.sendOTP({required String email}) =
      _SendOTPEvent;
  const factory ForgetPasswordEvent.verifyOTP({
    required String email,
    required String otp,
  }) = _VerifyOTPEvent;
  const factory ForgetPasswordEvent.validateEmail(String email) =
      _ValidateEmailEvent;
  const factory ForgetPasswordEvent.validateOTP(String otp) = _ValidateOTPEvent;
  const factory ForgetPasswordEvent.validatePassword(
    String email,
    String password,
    String confirmPassword,
  ) = _ValidatePasswordEvent;
  const factory ForgetPasswordEvent.resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) = _ResetPasswordEvent;
}
