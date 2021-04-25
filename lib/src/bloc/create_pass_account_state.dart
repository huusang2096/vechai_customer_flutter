import 'package:veca_customer/src/bloc/base_state.dart';


class InitialCreatePassAccountState extends  BaseState {}

class PassWordValidateError extends BaseState {
  final String newPasswordError;
  final String confrimPasswordError;

   PassWordValidateError(
    this.newPasswordError,
     this.confrimPasswordError);

}

class LoginOTPSuccessState extends BaseState{
  String message;

  LoginOTPSuccessState(this.message);
}


class CreateAccountState extends BaseState {
  final String message;

  CreateAccountState(this.message);
}

