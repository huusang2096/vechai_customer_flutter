import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NewPasswordState extends Equatable {
  const NewPasswordState();

  @override
  List<Object> get props => [];
}

class InitialChangePasswordState extends NewPasswordState {}

class ChangePasswordLoading extends NewPasswordState {}

class ChangePasswordDismiss extends NewPasswordState {}

class ChangePasswordFailure extends NewPasswordState {
  final String error;

  const ChangePasswordFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class PassWordValidateError extends NewPasswordState {
  final String newPasswordError;
  final String confrimPasswordError;

  const PassWordValidateError({
      @required this.newPasswordError,
      @required this.confrimPasswordError});

  @override
  List<Object> get props =>
      [newPasswordError, confrimPasswordError];
}

class ChangePassSuccess extends NewPasswordState {
  final String message;

  const ChangePassSuccess({this.message});

  @override
  List<Object> get props => [message];
}
