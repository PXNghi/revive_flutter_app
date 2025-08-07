import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_image_response.freezed.dart';
part 'upload_image_response.g.dart';

@freezed 
class UploadImageResponse with _$UploadImageResponse {
  const factory UploadImageResponse({
    @JsonKey(name: 'urls') @Default([]) List<String> url,
  }) = _UploadImageResponse;

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) => _$UploadImageResponseFromJson(json);
}