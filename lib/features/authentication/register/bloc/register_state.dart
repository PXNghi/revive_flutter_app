
part of 'register_bloc.dart';

@freezed 
class RegisterState with _$RegisterState {
  const factory RegisterState.initial() = Initial;
  const factory RegisterState.loading() = Loading;
  const factory RegisterState.loaded() = Loaded;
  const factory RegisterState.success() = Success;
  const factory RegisterState.error(String message) = Error;
}