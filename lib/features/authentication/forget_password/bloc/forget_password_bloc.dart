import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/features/authentication/auth_usecases.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';
part 'forget_password_bloc.freezed.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final AuthUsecases _authUsecases = AuthUsecases();
  String email = "";
  ForgetPasswordBloc() : super(const ForgetPasswordState.forgetInitial()) {
    on<_ValidateEmailEvent>(_handleValidateEmail);
    on<_ValidateOTPEvent>(_handleValidateOTP);
    on<_ValidatePasswordEvent>(_handleValidatePassword);
    on<_SendOTPEvent>(_handleSendOTP);
    on<_VerifyOTPEvent>(_handleVerifyOTP);
    on<_ResetPasswordEvent>(_handleResetPassword);
  }

  FutureOr<void> _handleSendOTP(
    _SendOTPEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(const ForgetPasswordState.forgetLoading());
    final response = await _authUsecases.sendForgetPasswordOTP(event.email);
    if (response.success) {
      emit(const ForgetPasswordState.sendOTPSuccess());
      emit(const ForgetPasswordState.forgetInitial());
    } else {
      emit(ForgetPasswordState.forgetError(response.message));
      emit(const ForgetPasswordState.forgetInitial());
    }
  }

  FutureOr<void> _handleValidateEmail(
    _ValidateEmailEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    if (state is ForgetInitial) {
      final initState = state as ForgetInitial;
      String? emailError;
      if (event.email.isEmpty) {
        emailError = "Không được để trống";
      } else if (!emailRegex.hasMatch(event.email.trim())) {
        emailError = "Định dạng email không đúng";
      }

      final isValid = emailError == null;

      emit(initState.copyWith(emailError: emailError));

      if (isValid) {
        email = event.email.trim();
        add(ForgetPasswordEvent.sendOTP(email: event.email.trim()));
      }
    }
  }

  FutureOr<void> _handleValidateOTP(
    _ValidateOTPEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    if (state is ForgetInitial) {
      final initState = state as ForgetInitial;
      String? otp;
      if (event.otp.isEmpty) {
        otp = "Không được để trống";
      }

      emit(initState.copyWith(otpError: otp));

      if (event.otp.isNotEmpty) {
        add(ForgetPasswordEvent.verifyOTP(email: email, otp: event.otp));
      }
    }
  }

  FutureOr<void> _handleValidatePassword(
    _ValidatePasswordEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    if (state is ForgetInitial) {
      final initState = state as ForgetInitial;
      String? passwordError;
      String? confirmPasswordError;

      if (event.password.isEmpty) {
        passwordError = "Không được để trống";
      } else if (!passwordRegex.hasMatch(event.password)) {
        passwordError =
            "Mật khẩu phải có ít nhất 6 chữ số và 1 chữ cái in hoa";
      }

      if (event.confirmPassword.isEmpty) {
        confirmPasswordError = "Không được để trống";
      } else if (event.password != event.confirmPassword) {
        confirmPasswordError = "Mật không không trùng khớp";
      }

      final isValid = passwordError == null && confirmPasswordError == null;

      emit(initState.copyWith(
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
      ));

      if (isValid) {
        add(ForgetPasswordEvent.resetPassword(
          email: event.email,
          password: event.password,
          confirmPassword: event.confirmPassword,
        ));
      }
    }
  }

  FutureOr<void> _handleVerifyOTP(
    _VerifyOTPEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(const ForgetPasswordState.forgetLoading());
    final response =
        await _authUsecases.verifyForgetPasswordOTP(event.email, event.otp);
    if (response.success) {
      emit(const ForgetPasswordState.forgetSuccess());
    } else {
      emit(ForgetPasswordState.forgetError(response.message));
      emit(const ForgetPasswordState.forgetInitial());
    }
  }

  FutureOr<void> _handleResetPassword(
    _ResetPasswordEvent event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    emit(const ForgetPasswordState.forgetLoading());
    final response = await _authUsecases.resetPassword(
      event.email,
      event.password,
      event.confirmPassword,
    );
    if (response.success) {
      emit(const ForgetPasswordState.resetPasswordSuccess());
    } else {
      emit(ForgetPasswordState.forgetError(response.message));
      emit(const ForgetPasswordState.forgetInitial());
    }
  }
}
