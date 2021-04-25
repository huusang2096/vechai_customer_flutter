import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';
import 'package:veca_customer/src/models/user_response.dart';

class InitialDrawerState extends BaseState {}

class UserAccountSuccess extends BaseState {
  Account user;
  UserAccountSuccess(this.user);
}
