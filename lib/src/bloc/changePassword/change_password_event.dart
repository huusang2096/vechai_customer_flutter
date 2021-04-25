import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ChangePasswordEvent extends Equatable {
  @override
  List<Object> get props => [];

  const ChangePasswordEvent();

}

class SendNewPassword extends ChangePasswordEvent{
  final String oldPassword, newPassword, confrimPassword;

  SendNewPassword({@required this.oldPassword, @required this.newPassword, @required this.confrimPassword});

  @override
  List<Object> get props => [oldPassword, newPassword, confrimPassword];
}

class OldPasswordChange extends ChangePasswordEvent{
  final String oldPassword;

  OldPasswordChange({@required this.oldPassword});

  @override
  List<Object> get props => [oldPassword];
}

class NewPasswordChange extends ChangePasswordEvent{
  final String newPassword;

  NewPasswordChange({@required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}

class ConfrimPasswordChange extends ChangePasswordEvent{
  final String confrimPassword;

  ConfrimPasswordChange({@required this.confrimPassword});

  @override
  List<Object> get props => [confrimPassword];
}