import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';
import 'package:veca_customer/src/models/user_response.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';

class DrawerBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialDrawerState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if (event is DrawerEventUser) {
      Account account = await Prefs.getAccount();
      yield UserAccountSuccess(account);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }
}
