part of 'location_bloc.dart';

@freezed 
class LocationState with _$LocationState {
  const factory LocationState.initial() = InitialLocationState;
  const factory LocationState.permissionDenied() = PermissionDeniedLocationState;
  const factory LocationState.permissionGranted() = PermissionGrantedLocationState;
  const factory LocationState.fetchingLocation() = FetchingLocationState;
  const factory LocationState.fetchingSuccess({Position? currentPosition, String? address}) = FetchingSuccessLocationState;
  const factory LocationState.error(String message) = ErrorLocationState;
}