import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/AddressModel.dart';

class InitialPlaceAddressState extends BaseState {}

class UploadAddressSuccessState extends BaseState {
  String message;
  AddressModel addressModel;
  UploadAddressSuccessState(this.message, this.addressModel);
}
