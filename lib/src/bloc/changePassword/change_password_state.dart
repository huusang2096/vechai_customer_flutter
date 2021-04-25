import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class InitialChangePasswordState extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordDismiss extends ChangePasswordState {}

class ChangePasswordFailure extends ChangePasswordState {
  final String error;

  const ChangePasswordFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class PassWordValidateError extends ChangePasswordState {
  final String oldPasswordError;
  final String newPasswordError;
  final String confrimPasswordError;

  const PassWordValidateError(
      {@required this.oldPasswordError,
      @required this.newPasswordError,
      @required this.confrimPasswordError});

  @override
  List<Object> get props =>
      [oldPasswordError, newPasswordError, confrimPasswordError];
}

class ChangePassSuccess extends ChangePasswordState {
  final String message;

  const ChangePassSuccess({this.message});

  @override
  List<Object> get props => [message];
}
