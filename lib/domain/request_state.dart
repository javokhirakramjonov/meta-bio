import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_state.freezed.dart';

@freezed
class RequestState<T> with _$RequestState {
  const factory RequestState.initial() = RequestStateInitial;

  const factory RequestState.loading() = RequestStateLoading;

  const factory RequestState.success(T data) = RequestStateSuccess;

  const factory RequestState.error(String errorMessage) = RequestStateError;
}
