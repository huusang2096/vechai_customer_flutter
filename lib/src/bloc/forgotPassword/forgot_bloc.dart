import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/common/validator.dart';
import './bloc.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  var email = '';
  var isEmailValid = false;

  @override
  ForgotState get initialState => InitialForgotPasswordState();

  final Repository repository;

  ForgotBloc({this.repository});

  @override
  Stream<ForgotState> mapEventToState(
    ForgotEvent event,
  ) async* {
    // TODO: Add Logic
    if (event is EmailForgotChange) {
      this.email = event.email;
      this.isEmailValid = false;
      if (email.isEmpty) {
        yield EmailForgotrValidateError(error: 'Phone_cannot_empty');
      } else if (!Validator.isValidEmail(email)) {
        yield EmailForgotrValidateError(error: 'email_format_invalid');
      } else {
        this.isEmailValid = true;
        yield EmailForgotrValidateError(error: '');
      }
    }

    if(event is SendEmail){
      this.email = event.email;
      if(this.isEmailValid){
        yield SendEmailLoading();
       /* try {
          var forgotresponse = await repository.sendEmaiForgot(
              email: this.email);
          if(forgotresponse.success){
            yield SendEmailSuccess();
          } else {
            yield SendEmailFailure(error: forgotresponse.message);
          }
        } catch (error) {
          yield SendEmailFailure(error: error.toString());
        } finally {
          yield SendEmailDismiss();
        }*/
      }
    }
  }
}
