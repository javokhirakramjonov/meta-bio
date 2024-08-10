import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_state.freezed.dart';

@freezed
class RequestState<T> with _$RequestState<T> {
  const factory RequestState.initial() = RequestStateInitial<T>;
  const factory RequestState.loading() = RequestStateLoading<T>;
  const factory RequestState.success({T? data}) = RequestStateSuccess<T>;
  const factory RequestState.error(String message) = RequestStateError<T>;
}