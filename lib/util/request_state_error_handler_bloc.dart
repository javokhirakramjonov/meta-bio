import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/component/snackbar.dart';

abstract class RequestStateHandlerBloc<Event, State>
    extends Bloc<Event, State> {
  RequestStateHandlerBloc(super.initialState, BuildContext context) {
    _listenToSuccessMessages(context);
    _listenToErrorMessages(context);
  }

  final _successMessages = StreamController<String>.broadcast();
  final _errorMessages = StreamController<String>.broadcast();

  void handleRequestState(RequestState requestState,
      {String? successMessage, String? errorMessage}) {
    if (requestState is RequestStateSuccess<Object?>) {
      if (successMessage != null) {
        _successMessages.add(successMessage);
      }
    } else if (requestState is RequestStateError) {
      _errorMessages.add(errorMessage ?? requestState.errorMessage);
    }
  }

  void _listenToSuccessMessages(BuildContext context) {
    _successMessages.stream.listen((successMessage) {
      showSuccessSnackBar(context, successMessage);
    });
  }

  void _listenToErrorMessages(BuildContext context) {
    _errorMessages.stream.listen((errorMessage) {
      showErrorSnackBar(context, errorMessage);
    });
  }

  @override
  Future<void> close() {
    _successMessages.close();
    _errorMessages.close();
    return super.close();
  }
}
