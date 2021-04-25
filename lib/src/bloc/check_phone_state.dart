import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/login_account_request.dart';

class InitialCheckPhoneState extends BaseState {}

class OpenOTPState extends BaseState {
  OpenOTPState();
}

class OpenLoginState extends BaseState {
  LoginAccountRequest loginAccountRequest;

  OpenLoginState(this.loginAccountRequest);
}