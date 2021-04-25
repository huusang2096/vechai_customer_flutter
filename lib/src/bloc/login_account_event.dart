import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/models/login_account_request.dart';

class LoginWithAccount extends BaseEvent{
  LoginAccountRequest loginAccountRequest;
  LoginWithAccount(this.loginAccountRequest);
}

class PasswordChange extends BaseEvent{
  final String password;
  PasswordChange( this.password);

}