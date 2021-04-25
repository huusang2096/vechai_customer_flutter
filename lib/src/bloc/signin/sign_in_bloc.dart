import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/common/validator.dart';
import './bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  var email = '';
  var password = '';
  var isEmailValid = false;
  var isPasswordValid = false;
  final Repository repository;

  SignInBloc({this.repository});

  @override
  SignInState get initialState => InitialSignInState();

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInEmailChange) {
      this.email = event.email;
      this.isEmailValid = false;
      if (email.isEmpty) {
        yield SignInEmailValidateError(error: 'Phone_cannot_empty');
      } else if (!Validator.isValidEmail(email)) {
        yield SignInEmailValidateError(error: 'email_format_invalid');
      } else {
        this.isEmailValid = true;
        yield SignInEmailValidateError(error: '');
      }
    }

    if (event is SignInPasswordChange) {
      this.isPasswordValid = false;
      this.password = event.password;
      if (!Validator.isValidPassword(password)) {
        yield SignInPasswordValidateError(error: 'pass_format_invalid');
      } else {
        this.isPasswordValid = true;
        yield SignInPasswordValidateError(error: '');
      }
    }

    if (event is SignInButtonPressed) {
      if (isPasswordValid && isEmailValid) {
        yield SignInLoading();
        try {
         /* var userResponse = await repository.loginEmail(
              email: this.email, password: this.password);
          if (userResponse.data != null) {
            _saveUser(userResponse.data);
          }*/
          yield SignInSuccess();
        } catch (error) {
          yield SignInFailure(error: error.toString());
        } finally {
          yield SignInDismiss();
        }
      }
    }
  }

  /*_saveUser(User user) async {
    await Prefs.saveUser(user);
    if (user.apiToken != null && user.apiToken.isNotEmpty) {
      await Prefs.saveToken(user.apiToken);
      await Prefs.setNeedToShowWalkThrough(false);
    }
  }*/
}
