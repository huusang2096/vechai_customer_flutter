import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_state.dart';

class InitialOtpState extends BaseState {}

class SendOTPSuccessState extends BaseState {
  String message;

  SendOTPSuccessState(this.message);
}