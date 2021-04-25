import 'package:meta/meta.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';
import 'package:veca_customer/src/models/UploadImageResponse.dart';

import 'base_state.dart';

class UpdateProfileState extends BaseState {}

class UploadImageSuccessState extends BaseState {
  UploadImageResponse uploadImageResponse;

  UploadImageSuccessState(this.uploadImageResponse);
}

class UploadProfileSuccessState extends BaseState {
  AccountResponse accountResponse;

  UploadProfileSuccessState(this.accountResponse);
}
