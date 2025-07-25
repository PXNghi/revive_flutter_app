part of "location_bloc.dart";

@freezed 
class LocationEvent with _$LocationEvent {
  const factory LocationEvent.requestLocationPermission() = _RequestLocationPermissionEvent;
  const factory LocationEvent.getLocation() = _GetLocationEvent;
}