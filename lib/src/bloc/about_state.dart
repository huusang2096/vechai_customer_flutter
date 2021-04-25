import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/AboutResponse.dart';

class InitialAboutState extends BaseState {}

class GetAboutDataSucces extends BaseState {
  AboutResponse aboutResponse;
  GetAboutDataSucces(this.aboutResponse);
}

