import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/person/models/user.dart';
import 'package:revive_flutter_project/features/person/user_usecases.dart';

part 'user_management_event.dart';
part 'user_management_state.dart';
part 'user_management_bloc.freezed.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  final UserUsecases _userUsecases = UserUsecases();
  UserManagementBloc() : super(const UserManagementState.initial()) {
    on<_GetAllUsers>(_handleGetAllUsers);
    on<_ActivateUser>(_handleActivateUser);
    on<_DeactivateUser>(_handleDeactivateUser);
  }

  FutureOr<void> _handleGetAllUsers(
    _GetAllUsers event,
    Emitter<UserManagementState> emit,
  ) async {
    try {
      emit(const UserManagementState.loading());
      final List<User> users = await _userUsecases.getAllUsers();
      emit(UserManagementState.loaded(users: users));
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  FutureOr<void> _handleActivateUser(
    _ActivateUser event,
    Emitter<UserManagementState> emit,
  ) async {
    try {
      emit(const UserManagementState.loading());
      final bool success = await _userUsecases.activateUser(event.userId);
      if (success) {
        add(const UserManagementEvent.getAllUsers());
      } else {
        emit(const UserManagementState.error("Error activating user"));
      }
    } catch (e) {
      emit(UserManagementState.error(e.toString()));
      print("Error activating user: $e");
    }
  }

  FutureOr<void> _handleDeactivateUser(
    _DeactivateUser event,
    Emitter<UserManagementState> emit,
  ) async {
    try {
      emit(const UserManagementState.loading());
      final bool success = await _userUsecases.deactivateUser(event.userId);
      if (success) {
        add(const UserManagementEvent.getAllUsers());
      } else {
        emit(const UserManagementState.error("Error deactivating user"));
      }
    } catch (e) {
      emit(UserManagementState.error(e.toString()));
      print("Error deactivating user: $e");
    }
  }
}
