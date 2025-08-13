import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/services/socket_service.dart';
import 'package:revive_flutter_project/features/authentication/auth_usecases.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthUsecases _authUsecase = AuthUsecases();
  final SocketService _socketService = SocketService();

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
    if (response.success) {
      emit(const LoginState.loginSuccess());
      emit(const LoginState.loginLoaded());
      _socketService.connect(SessionData.mine!.id);
    } else {
      emit(LoginState.loginError(response.message));
      emit(const LoginState.loginLoaded());
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
        emailError = "Không được để trống";
      } else if (!emailRegex.hasMatch(event.email.trim())) {
        emailError = "Định dạng email không đúng";
      }
      
      if (event.password.isEmpty) {
        passwordError = "Không được để trống";
      } else if (!passwordRegex.hasMatch(event.password)) {
        passwordError = "Mật khẩu phải có ít nhất 6 chữ số và 1 chữ cái in hoa";
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
