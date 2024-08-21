import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta_bio/domain/request_state.dart';
import 'package:meta_bio/ui/component/snackbar.dart';

abstract class RequestStateErrorHandlerBloc<Event, State>
    extends Bloc<Event, State> {
  RequestStateErrorHandlerBloc(super.initialState, BuildContext context) {
    _listenToErrorMessages(context);
  }

  final _errorMessages = StreamController<String>.broadcast();

  void handleRequestStateError(RequestState requestStateError) {
    if (requestStateError is RequestStateError) {
      _errorMessages.add(requestStateError.errorMessage);
    }
  }

  void _listenToErrorMessages(BuildContext context) {
    _errorMessages.stream.listen((errorMessage) {
      showErrorSnackBar(context, errorMessage);
    });
  }

  @override
  Future<void> close() {
    _errorMessages.close();
    return super.close();
  }
}
