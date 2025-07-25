
import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';
part 'branch.g.dart';

@freezed
class Branch with _$Branch {
  const factory Branch({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: "district") @Default("") String district,
    @JsonKey(name: "address") @Default("") String address,
    @JsonKey(name: "location") required Location location,
  }) = _Branch;

  factory Branch.fromJson(Map<String,Object?> json) => _$BranchFromJson(json);
}

@freezed 
class Location with _$Location {
  const factory Location({
    @JsonKey(name: "coordinates") required List<double> coordinates,
  }) = _Location;

  factory Location.fromJson(Map<String,Object?> json) => _$LocationFromJson(json);
}