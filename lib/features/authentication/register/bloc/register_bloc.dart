import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/authentication/auth_usecases.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthUsecases _authUsecase = AuthUsecases();
  RegisterBloc() : super(const RegisterState.initial()) {
    on<_RegisterEventRegister>(_handleRegister);
  }

  FutureOr<void> _handleRegister(
    _RegisterEventRegister event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState.loading());
    final bool response = await _authUsecase.register(
      fullName: event.name,
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmedPassword,
    );
    if (response) {
      emit(const RegisterState.loaded());
    } else {
      emit(const RegisterState.error("There's something wrong. Please try again!"));
    }
  }
}
