import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/models/LoginTokenRequest.dart';

class SendNewPassword extends BaseEvent{
  final newPassword, otp, phonecode, phoneNumber;

  SendNewPassword(this.newPassword, this.otp,this.phonecode, this.phoneNumber);
}

class NewPasswordChange extends BaseEvent{
  final String newPassword;
  NewPasswordChange( this.newPassword);

}

class LoginOTPEvent extends BaseEvent {
  LoginTokenRequest loginTokenRequest;

  LoginOTPEvent(this.loginTokenRequest);
}

class ConfrimPasswordChange extends BaseEvent{
  final String confrimPassword;

  ConfrimPasswordChange(this.confrimPassword);
}
