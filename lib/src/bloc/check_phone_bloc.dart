import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/models/RequestPhoneNumberResponse.dart';
import 'package:veca_customer/src/models/login_account_request.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import 'package:veca_customer/src/uitls/device_helper.dart';
import './bloc.dart';

class CheckPhoneBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOtpState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if(event is CheckPhoneEvent){
      yield* _checkPhoneNumber(event.requestPhoneNumberResponse);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _checkPhoneNumber(RequestPhoneNumberResponse requestPhoneNumberResponse) async* {
    yield LoadingState(true);
    var response = await Repository.instance.checkPhoneNumber(requestPhoneNumberResponse);
    if (response != null) {
      yield LoadingState(false);
      if (response.data.status) {
        LoginAccountRequest accountRequest = new LoginAccountRequest();
        accountRequest.phoneCountryCode = requestPhoneNumberResponse.phoneCountryCode;
        accountRequest.phoneNumber = requestPhoneNumberResponse.phoneNumber;
        accountRequest.deviceId = await DeviceHelper.instance.getId();
        accountRequest.accountType = 1;
        accountRequest.isoCode = requestPhoneNumberResponse.iSOCode;

        yield OpenLoginState(accountRequest);
        await Prefs.saveHasAccount(true);
      } else {
        yield OpenOTPState();
        await Prefs.saveHasAccount(false);
      }
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }
}
