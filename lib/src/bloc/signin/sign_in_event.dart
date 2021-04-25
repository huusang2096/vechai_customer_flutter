import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
  @override
  List<Object> get props => [];

}

class SignInButtonPressed extends SignInEvent {
  final String email;
  final String password;

  const SignInButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'SiginButtonPressed { email: $email, password: $password }';
}

class SignInEmailChange extends SignInEvent {
  final String email;
  const SignInEmailChange({@required this.email});
  @override
  List<Object> get props => [email];
}

class SignInPasswordChange extends SignInEvent {
  final String password;
  const SignInPasswordChange({@required this.password});
  @override
  List<Object> get props => [password];
}
