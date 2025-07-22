import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/features/authentication/auth_usecases.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthUsecases _authUsecase = AuthUsecases();

  LoginBloc() : super(const LoginState.loginLoaded()) {
    on<_Login>(_handleLogin);
    on<_ValidateInformations>(_handleValidateInformations);
  }

  FutureOr<void> _handleLogin(
    _Login event,
    Emitter<LoginState> emit,
  ) async {
    final email = event.email.trim();
    final password = event.password.trim();
    emit(const LoginState.loginLoading());
    final response = await _authUsecase.login(email, password);
    if (response) {
      emit(const LoginState.loginSuccess());
      emit(const LoginState.loginLoaded());
    } else {
      emit(const LoginState.loginError("Invalid credentials"));
    }
  }

  FutureOr<void> _handleValidateInformations(
    _ValidateInformations event,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginLoaded) {
      final loadedState = state as LoginLoaded;
      String? emailError;
      String? passwordError;

      if (event.email.isEmpty) {
        emailError = "Email is required";
      } else if (!emailRegex.hasMatch(event.email.trim())) {
        emailError = "Invalid email format";
      }
      
      if (event.password.isEmpty) {
        passwordError = "Password is required";
      } else if (!passwordRegex.hasMatch(event.password)) {
        passwordError = "Password must has at least 6 characters and at least one uppercase letter";
      }

      final isValid = emailError == null && passwordError == null;

      emit(
        loadedState.copyWith(
          emailError: emailError,
          passwordError: passwordError,
        ),
      );

      if (isValid) {
        add(LoginEvent.login(email: event.email, password: event.password));
      }
    }
  }
}
