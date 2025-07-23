part of 'login_bloc.dart';

@freezed 
class LoginState with _$LoginState {
  const factory LoginState.loginInitial() = LoginInitial;
  const factory LoginState.loginLoading() = LoginLoading;
  const factory LoginState.loginLoaded({
    @Default('') String email,
    @Default('') String password,
    String? emailError,
    String? passwordError,
    @Default(false) bool isValid,
  }) = LoginLoaded;
  const factory LoginState.loginSuccess() = LoginSuccess;
  const factory LoginState.loginError(String message) = LoginError;

  const LoginState._();
}