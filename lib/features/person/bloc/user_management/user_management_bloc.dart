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
}
