import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_state.dart';

class InitialLoginAccountState extends BaseState {}

class LoginAccountSuccess extends BaseState {
  String message;
  LoginAccountSuccess(this.message);
}

class LoginWithPasswordValidateError extends BaseState {
  final String error;

  LoginWithPasswordValidateError( this.error);

}
