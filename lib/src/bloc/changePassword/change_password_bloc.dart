import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/common/validator.dart';
import 'package:veca_customer/src/models/ChangePassRequest.dart';
import 'package:veca_customer/src/network/Repository.dart';
import './bloc.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  var oldPassword = "";
  var newPassword = "";
  var confirmPassword = "";

  @override
  ChangePasswordState get initialState => InitialChangePasswordState();

  final Repository repository;

  ChangePasswordBloc({this.repository});

  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event,
      ) async* {
    if (event is OldPasswordChange) {
      oldPassword = event.oldPassword;
    }

    if (event is NewPasswordChange) {
      newPassword = event.newPassword;
    }

    if (event is ConfrimPasswordChange) {
      confirmPassword = event.confrimPassword;
    }

    var validateState = _validateInfor();

    yield PassWordValidateError(oldPasswordError: validateState.oldPasswordError,
        newPasswordError: validateState.newPasswordError,
        confrimPasswordError: validateState.confrimPasswordError);

    if (event is SendNewPassword &&
        validateState.oldPasswordError.isEmpty &&
        validateState.newPasswordError.isEmpty &&
        validateState.confrimPasswordError.isEmpty) {
      yield ChangePasswordLoading();
      try {

        ChangePassRequest changePassRequest = new ChangePassRequest();
        changePassRequest.newPassword = newPassword;
        changePassRequest.oldPassword = oldPassword;

        var userResponse = await repository.changePass(changePassRequest);
        if (userResponse.success) {
          yield ChangePassSuccess(message: userResponse.message);
        } else if (!userResponse.success) {
          yield ChangePasswordFailure(error: userResponse.message);
        }
      } catch (error) {
        print(error);
        yield ChangePasswordFailure(error: error);
      } finally {
        yield ChangePasswordDismiss();
      }
    }
  }

  PassWordValidateError _validateInfor() {
    var oldPasswordError = "";
    if (this.oldPassword.isEmpty) {
      oldPasswordError = "password_cannot_empty";
    } else if (!Validator.isValidPassword(this.oldPassword)) {
      oldPasswordError = "pass_format_invalid";
    }

    var newPasswordError = "";
    if (this.newPassword.isEmpty) {
      newPasswordError = "password_cannot_empty";
    } else if (!Validator.isValidPassword(this.newPassword)) {
      newPasswordError = "pass_format_invalid";
    }

    var confrimPasswordError = "";
    if (this.confirmPassword.isEmpty) {
      confrimPasswordError = "password_cannot_empty";
    } else if (!Validator.isValidPassword(this.confirmPassword)) {
      confrimPasswordError = "pass_format_invalid";
    }

    if (!this.newPassword.isEmpty && !this.confirmPassword.isEmpty && this.newPassword != this.confirmPassword) {
      confrimPasswordError = "password_does_not_match";
    }

    return PassWordValidateError(
        oldPasswordError: oldPasswordError,
        newPasswordError: newPasswordError,
        confrimPasswordError: confrimPasswordError);
  }
}
