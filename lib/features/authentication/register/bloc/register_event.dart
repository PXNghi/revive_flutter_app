
part of 'register_bloc.dart';

@freezed 
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.register({
    required String name,
    required String email,
    required String password,
    required String confirmedPassword,
  }) = _RegisterEventRegister;

  const factory RegisterEvent.validateInformations({
    required String name,
    required String email,
    required String password,
    required String confirmedPassword,
  }) = _RegisterEventValidateInformations;

  const factory RegisterEvent.verifyAccount({
    required String otp,
    required String email,
  }) = _RegisterEventVerifyAccount;

  const factory RegisterEvent.resendOTP({required String email}) = _RegisterEventResendOTP;
}