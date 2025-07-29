
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed 
class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'full_name') required String name,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'role') @Default('User') String role,
    @JsonKey(name: 'phone') @Default('') String phone,
    @JsonKey(name: 'avatar') @Default('') String avatar,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'addresses') @Default([]) List<Address> addresses
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

@freezed 
class Address with _$Address {
  const factory Address({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'address') required String address,
    @JsonKey(name: 'location') required CustomLocation location,
  }) = _Address;

  factory Address.fromJson(Map<String, Object?> json) => _$AddressFromJson(json);
}

@freezed 
class CustomLocation with _$CustomLocation {
  const factory CustomLocation({
    @JsonKey(name: 'coordinates') required List<double> coordinates // [lon, lat]
  }) = _Location;

  factory CustomLocation.fromJson(Map<String, Object?> json) => _$CustomLocationFromJson(json);
}
