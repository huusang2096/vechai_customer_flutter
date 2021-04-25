import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ForgotEvent extends Equatable {
  const ForgotEvent();

  @override
  List<Object> get props => [];
}

class SendEmail extends ForgotEvent{
  final String email;

  SendEmail({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'SendEmailButtonPressed { email: $email}';
}


class EmailForgotChange extends ForgotEvent{
  final String email;

  EmailForgotChange({@required this.email});

  @override
  List<Object> get props => [email];

}