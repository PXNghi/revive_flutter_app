import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_flutter_project/features/person/models/user.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

@freezed 
class Participant with _$Participant {
  const factory Participant({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'userId') required User user,
    @JsonKey(name: 'role') @Default('') String role,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) => _$ParticipantFromJson(json);
}