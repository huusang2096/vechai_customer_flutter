import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class InitialSignInState extends SignInState {}

class SignInLoading extends SignInState {}

class SignInDismiss extends SignInState {}

class SignInFailure extends SignInState {
  final String error;

  const SignInFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignInFailure { error: $error }';
}

class SignInEmailValidateError extends SignInState {
  final String error;

  const SignInEmailValidateError({@required this.error});

  @override
  List<Object> get props => [error];
}

class SignInPasswordValidateError extends SignInState {
  final String error;

  const SignInPasswordValidateError({@required this.error});

  @override
  List<Object> get props => [error];
}

class SignInSuccess extends SignInState {}
