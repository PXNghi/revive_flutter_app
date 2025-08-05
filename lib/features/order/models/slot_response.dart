import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot_response.freezed.dart';
part 'slot_response.g.dart';

@freezed
class SlotResponse with _$SlotResponse {
  const factory SlotResponse({
    @JsonKey(name: 'date') @Default('') String date,
    @JsonKey(name: 'slots') @Default([]) List<SlotDateTime> slots,
  }) = _SlotResponse;

  factory SlotResponse.fromJson(Map<String, Object?> json) =>
      _$SlotResponseFromJson(json);
}

@freezed
class SlotDateTime with _$SlotDateTime {
  const factory SlotDateTime({
    @JsonKey(name: 'start', fromJson: _fromJson, toJson: _toJson)
    required DateTime startTime,

    @JsonKey(name: 'end', fromJson: _fromJson, toJson: _toJson)
    required DateTime endTime,

    @JsonKey(name: 'available') required int available,
  }) = _SlotDateTime;

  factory SlotDateTime.fromJson(Map<String, Object?> json) =>
      _$SlotDateTimeFromJson(json);
}

DateTime _fromJson(String date) => DateTime.parse(date).toLocal();
String _toJson(DateTime date) => date.toIso8601String();
