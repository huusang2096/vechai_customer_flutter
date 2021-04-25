import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/models/RequestPhoneNumberResponse.dart';

class CheckPhoneEvent extends BaseEvent {
  RequestPhoneNumberResponse requestPhoneNumberResponse;

  CheckPhoneEvent(this.requestPhoneNumberResponse);
}