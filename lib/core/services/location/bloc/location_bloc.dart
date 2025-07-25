import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:revive_flutter_project/core/services/location/models/address.dart';
import 'package:revive_flutter_project/core/services/session_data.dart';
import 'package:revive_flutter_project/core/utils/permission_utils.dart';
import 'package:revive_flutter_project/features/person/user_usecases.dart';

part 'location_event.dart';
part 'location_state.dart';
part 'location_bloc.freezed.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final UserUsecases _userUsecase = UserUsecases();
  LocationBloc() : super(const LocationState.initial()) {
    on<_RequestLocationPermissionEvent>(_handleRequestLocationPermission);
    on<_GetLocationEvent>(_handleGetLocationEvent);
  }

  FutureOr<void> _handleRequestLocationPermission(
    _RequestLocationPermissionEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      final granted = await PermissionUtils.requestLocationPermission();
      if (granted) {
        emit(const LocationState.permissionGranted());
        add(const LocationEvent.getLocation());
      } else {
        emit(const LocationState.permissionDenied());
      }
    } catch (e) {
      emit(LocationState.error(e.toString()));
    }
  }

  FutureOr<void> _handleGetLocationEvent(
    _GetLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationState.fetchingLocation());
      final position = await Geolocator.getCurrentPosition();
      final placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
      final address = "${placeMark[0].street}, ${placeMark[0].subAdministrativeArea}, ${placeMark[0].administrativeArea}";
      await updateUserAddress(address, position.latitude, position.longitude);
      emit(LocationState.fetchingSuccess(currentPosition: position, address: address));
    } catch (e) {
      emit(LocationState.error(e.toString()));
    }
  }

  Future<void> updateUserAddress(String address, double lat, double lon) async {
    try {
      final response = await _userUsecase.updateAddress(address, lat, lon);
      if (response) {
        await SessionData.updateAddress(Address(address: address, lat: lat, lon: lon));
        await _userUsecase.getUserProfileByToken(await SessionData.token());
      }
    } catch (e) {
      print("Error at update user address: $e");
    }
  }
}
