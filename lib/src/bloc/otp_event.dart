import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/models/LoginTokenRequest.dart';
import 'package:veca_customer/src/models/RequestPhoneNumberResponse.dart';

class SendOTPEvent extends BaseEvent {
  RequestPhoneNumberResponse requestPhoneNumberResponse;

  SendOTPEvent(this.requestPhoneNumberResponse);
}

class SendOTPDoneEvent extends BaseEvent {
  SendOTPDoneEvent();
}