import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/models/AddressRequest.dart';

class UploadAddress extends BaseEvent {
  AddressRequest addressRequest;

  UploadAddress(this.addressRequest);
}
