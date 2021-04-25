import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NewPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];

  const NewPasswordEvent();

}

class SendNewPassword extends NewPasswordEvent{
  final  newPassword, confrimPassword;

  SendNewPassword({ @required this.newPassword, @required this.confrimPassword});

  @override
  List<Object> get props => [newPassword, confrimPassword];
}

class NewPasswordChange extends NewPasswordEvent{
  final String newPassword;

  NewPasswordChange({@required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}

class ConfrimPasswordChange extends NewPasswordEvent{
  final String confrimPassword;

  ConfrimPasswordChange({@required this.confrimPassword});

  @override
  List<Object> get props => [confrimPassword];
}