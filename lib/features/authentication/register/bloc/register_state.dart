
part of 'register_bloc.dart';

@freezed 
class RegisterState with _$RegisterState {
  const factory RegisterState.initial({
    String? nameError,
    String? emailError,
    String? passwordError,
    String? confirmedPasswordError,
    String? otpError,
  }) = Initial;
  const factory RegisterState.loading() = Loading;
  const factory RegisterState.success() = Success;
  const factory RegisterState.resendOTPSuccess() = ResendOTPSuccess;
  const factory RegisterState.error(String message) = Error;

  const RegisterState._();

  String? get nameError => mapOrNull(initial: (value) => value.nameError);

  String? get emailError => mapOrNull(initial: (value) => value.emailError);

  String? get passwordError => mapOrNull(initial: (value) => value.passwordError);

  String? get confirmedPasswordError => mapOrNull(initial: (value) => value.confirmedPasswordError);

  String? get otpError => mapOrNull(initial: (value) => value.otpError);
}