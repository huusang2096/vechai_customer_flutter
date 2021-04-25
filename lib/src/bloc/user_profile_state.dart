import 'dart:io';

import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';
import 'package:veca_customer/src/models/UploadImageResponse.dart';

class InitialUserProfileState extends BaseState {}

class GetUserProfile extends BaseState {
  Account account;
  GetUserProfile(this.account);
}

class UploadProfileImageSuccessState extends BaseState {
  UploadImageResponse uploadImageResponse;

  UploadProfileImageSuccessState(this.uploadImageResponse);
}

class UpdateProfileSuccessState extends BaseState {
  AccountResponse accountResponse;

  UpdateProfileSuccessState(this.accountResponse);
}
