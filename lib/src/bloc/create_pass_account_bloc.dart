import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/validator.dart';
import 'package:veca_customer/src/models/AccountRequest.dart';
import 'package:veca_customer/src/models/LoginTokenRequest.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import 'package:veca_customer/src/uitls/device_helper.dart';
import './bloc.dart';

class CreatePassAccountBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
@override
BaseState get initialState => InitialOtpState();

var newPassword = "";
var confirmPassword = "";

@override
void onError(Object error, StackTrace stacktrace) {
  super.onError(error, stacktrace);
  blocHandleError(this, error);
}

@override
Stream<BaseState> mapEventToState(BaseEvent event,) async* {
  if (event is NewPasswordChange) {
    newPassword = event.newPassword;
  }

  if (event is ConfrimPasswordChange) {
    confirmPassword = event.confrimPassword;
  }

  var validateState = _validateInfor();

  yield PassWordValidateError(validateState.newPasswordError,
       validateState.confrimPasswordError);

  if (event is SendNewPassword &&
      validateState.newPasswordError.isEmpty &&
      validateState.confrimPasswordError.isEmpty) {
    yield* _createAccount(event.otp, event.newPassword, event.phonecode, event.phoneNumber);
  }

  if(event is LoginOTPEvent){
    yield* _loginOTp(event.loginTokenRequest);
  }

  if (event is InternalErrorEvent) {
    yield ErrorState(event.error);
  }
}

Stream<BaseState> _loginOTp(LoginTokenRequest loginTokenRequest) async* {
  yield LoadingState(true);
  loginTokenRequest.deviceId = await DeviceHelper.instance.getId();
  loginTokenRequest.platform = await DeviceHelper.instance.getDeviceType();
  final response = await Repository.instance.loginwithOTP(loginTokenRequest);
  if (response != null) {
    yield LoadingState(false);
    if(response.data.apiToken.isNotEmpty){
      await Prefs.saveToken(response.data.apiToken);
    }
    await Prefs.saveAccount(response.data);
    Repository.instance.reloadHeaders();
    yield LoginOTPSuccessState(response.message);
  } else {
    yield LoadingState(false);
    yield ErrorState('login_failed');
  }
}

Stream<BaseState> _createAccount(String otp_token, String new_password, String phonecode, String phoneNumber) async* {
  yield LoadingState(true);
  AccountRequest accountRequest = new AccountRequest();
  accountRequest.deviceId =  await DeviceHelper.instance.getId();
  accountRequest.otpToken = otp_token;
  accountRequest.newPassword = new_password;
  accountRequest.accountType = 1;
  accountRequest.phoneCountryCode = phonecode;
  accountRequest.phoneNumber = phoneNumber;
 accountRequest.platform = await DeviceHelper.instance.getDeviceType();

  final response = await Repository.instance.createAccpunt(accountRequest);
  if (response != null && response.data != null) {
    yield LoadingState(false);
    if(response.data.apiToken.isNotEmpty){
      await Prefs.saveToken(response.data.apiToken);
    }
    await Prefs.saveAccount(response.data);
    Repository.instance.reloadHeaders();
    yield CreateAccountState(response.message);
  } else {
    yield LoadingState(false);
    yield ErrorState('login_failed');
  }
}

PassWordValidateError _validateInfor() {
  var newPasswordError = "";
  if (this.newPassword.isEmpty) {
    newPasswordError = "password_cannot_empty";
  } else if (!Validator.isValidPassword(this.newPassword)) {
    newPasswordError = "pass_format_invalid";
  }

  var confrimPasswordError = "";
  if (this.confirmPassword.isEmpty) {
    confrimPasswordError = "password_cannot_empty";
  } else if (!Validator.isValidPassword(this.confirmPassword)) {
    confrimPasswordError = "pass_format_invalid";
  }

  if (!this.newPassword.isEmpty && !this.confirmPassword.isEmpty && this.newPassword != this.confirmPassword) {
    confrimPasswordError = "password_does_not_match";
  }



  return PassWordValidateError(
       newPasswordError,
       confrimPasswordError);
}
}


