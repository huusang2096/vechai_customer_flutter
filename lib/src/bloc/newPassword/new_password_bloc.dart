import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/common/validator.dart';
import './bloc.dart';

class NewPasswordBloc
    extends Bloc<NewPasswordEvent, NewPasswordState> {
  var oldPassword = "";
  var newPassword = "";
  var confirmPassword = "";

  @override
  NewPasswordState get initialState => InitialChangePasswordState();

  final Repository repository;

  NewPasswordBloc({this.repository});

  @override
  Stream<NewPasswordState> mapEventToState(
      NewPasswordEvent event,
  ) async* {
    if (event is NewPasswordChange) {
      newPassword = event.newPassword;
    }

    if (event is ConfrimPasswordChange) {
      confirmPassword = event.confrimPassword;
    }

    var validateState = _validateInfor();

    yield PassWordValidateError(newPasswordError: validateState.newPasswordError,
    confrimPasswordError: validateState.confrimPasswordError);

    if (event is SendNewPassword &&
        validateState.newPasswordError.isEmpty &&
        validateState.confrimPasswordError.isEmpty) {
      yield ChangePasswordLoading();
     /* try {
        var userResponse = await repository.updatePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confrimPassword: confirmPassword);

        if (userResponse.data != null && userResponse.success) {
          yield ChangePassSuccess(message: userResponse.message);
        } else if (!userResponse.success) {
          yield ChangePasswordFailure(error: userResponse.message);
        }
      } catch (error) {
        print(error);
        yield ChangePasswordFailure(error: error);
      } finally {
        yield ChangePasswordDismiss();
      }*/
    }
  }

  PassWordValidateError _validateInfor() {
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
        newPasswordError: newPasswordError,
        confrimPasswordError: confrimPasswordError);
  }
}
