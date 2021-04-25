import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';


abstract class ForgotState extends Equatable {
  const ForgotState();

  @override
  List<Object> get props => [];
}

class InitialForgotPasswordState extends ForgotState {}

class SendEmailLoading extends ForgotState {}

class SendEmailDismiss extends ForgotState {}

class SendEmailFailure extends ForgotState {
  final String error;

  const SendEmailFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SignInFailure { error: $error }';
}

class EmailForgotrValidateError extends ForgotState {
  final String error;

  const EmailForgotrValidateError({@required this.error});

  @override
  List<Object> get props => [error];
}

class SendEmailSuccess extends ForgotState {}
