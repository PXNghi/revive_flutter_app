import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/features/authentication/auth_usecases.dart';
import 'package:revive_flutter_project/features/authentication/models/auth_response.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthUsecases _authUsecase = AuthUsecases();
  RegisterBloc() : super(const RegisterState.initial()) {
    on<_RegisterEventRegister>(_handleRegister);
    on<_RegisterEventValidateInformations>(_handleValidateInformations);
    on<_RegisterEventVerifyAccount>(_handleVerifyAccount);
    on<_RegisterEventResendOTP>(_handleResendOTP);
  }

  FutureOr<void> _handleRegister(
    _RegisterEventRegister event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState.loading());
    final AuthResponse response = await _authUsecase.register(
      fullName: event.name,
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmedPassword,
    );
    if (response.success) {
      emit(const RegisterState.success());
    } else {
      emit(RegisterState.error(response.message));
      emit(const RegisterState.initial());
    }
  }

  FutureOr<void> _handleValidateInformations(
    _RegisterEventValidateInformations event,
    Emitter<RegisterState> emit,
  ) async {
    if (state is Initial) {
      final initState = state as Initial;

      String? nameError;
      String? emailError;
      String? passwordError;
      String? confirmPasswordError;

      if (event.name.isEmpty) {
        nameError = "Không được để trống";
      }

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

      if (event.confirmedPassword.isEmpty) {
        confirmPasswordError = "Không được để trống";
      } else if (event.password != event.confirmedPassword) {
        confirmPasswordError = "Mật không không trùng khớp";
      }

      final bool isValid = nameError == null &&
          emailError == null &&
          passwordError == null &&
          confirmPasswordError == null;

      emit(
        initState.copyWith(
          nameError: nameError,
          emailError: emailError,
          passwordError: passwordError,
          confirmedPasswordError: confirmPasswordError,
        ),
      );

      if (isValid) {
        add(
          RegisterEvent.register(
            name: event.name,
            email: event.email,
            password: event.password,
            confirmedPassword: event.confirmedPassword,
          ),
        );
      }
    }
  }

  FutureOr<void> _handleVerifyAccount(
    _RegisterEventVerifyAccount event,
    Emitter<RegisterState> emit,
  ) async {
    if (state is Initial) {
      final initState = state as Initial;
      if (event.otp.isEmpty) {
        emit(initState.copyWith(otpError: "Không được để trống"));
      } else {
        final response =
            await _authUsecase.verifyAccount(event.email, event.otp);
        if (response.success) {
          emit(const RegisterState.success());
        } else {
          emit(RegisterState.error(response.message));
          emit(const RegisterState.initial());
        }
      }
    }
  }

  FutureOr<void> _handleResendOTP(
    _RegisterEventResendOTP event,
    Emitter<RegisterState> emit,
  ) async {
    final response = await _authUsecase.resendOTP(event.email);
    if (response == true) {
      emit(const RegisterState.resendOTPSuccess());
      emit(const RegisterState.initial());
    } else {
      emit(const RegisterState.error("Không thành công, vui lòng thử lại!"));
      emit(const RegisterState.initial());
    }
  }
}
