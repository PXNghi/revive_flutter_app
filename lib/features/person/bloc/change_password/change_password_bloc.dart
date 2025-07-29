import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/core/constants/strings.dart';
import 'package:revive_flutter_project/features/person/user_usecases.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';
part 'change_password_bloc.freezed.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserUsecases _userUsecases = UserUsecases();
  ChangePasswordBloc() : super(const Initial()) {
    on<_ChangePassword>(_handleChangePassword);
  }

  FutureOr<void> _handleChangePassword(
    _ChangePassword event,
    Emitter<ChangePasswordState> emit,
  ) async {
    String? oldPasswordError;
    String? newPasswordError;
    String? confirmedPasswordError;

    if (event.oldPassword.isEmpty) {
      oldPasswordError = "Không được để trống";
    } else if (!passwordRegex.hasMatch(event.oldPassword)) {
      oldPasswordError =
          "Mật khẩu phải có ít nhất 6 chữ số và 1 chữ cái in hoa";
    }

    if (event.newPassword.isEmpty) {
      newPasswordError = "Không được để trống";
    } else if (!passwordRegex.hasMatch(event.newPassword)) {
      newPasswordError =
          "Mật khẩu phải có ít nhất 6 chữ số và 1 chữ cái in hoa";
    }

    if (event.confirmedPassword.isEmpty) {
      confirmedPasswordError = "Không được để trống";
    } else if (event.newPassword != event.confirmedPassword) {
      confirmedPasswordError = "Mật khẩu không khớp";
    }

    if (oldPasswordError != null ||
        newPasswordError != null ||
        confirmedPasswordError != null) {
      emit(
        ChangePasswordState.validateFailed(
          oldPasswordError: oldPasswordError,
          newPasswordError: newPasswordError,
          confirmedPasswordError: confirmedPasswordError,
        ),
      );
    } else {
      emit(const ChangePasswordState.loading());
      final message = await _userUsecases.changePassword(
        event.oldPassword,
        event.newPassword,
        event.confirmedPassword,
      );
      if (message == null) {
        emit(const ChangePasswordState.success("Thay đổi mật khẩu thành công"));
      } else {
        emit(ChangePasswordState.error(message));
      }
    }
  }
}
