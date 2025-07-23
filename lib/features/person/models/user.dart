
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
    @JsonKey(name: 'avatar') @Default('') String avatar
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
