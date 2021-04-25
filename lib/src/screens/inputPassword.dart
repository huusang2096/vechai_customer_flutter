import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/bloc/login_account_bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/RequestPhoneNumberResponse.dart';
import 'package:veca_customer/src/models/login_account_request.dart';

class InputPasswordWidget extends StatefulWidget {
  LoginAccountRequest loginAccountRequest;

  InputPasswordWidget({Key key, this.loginAccountRequest}) {
    loginAccountRequest = this.loginAccountRequest;
  }

  static provider(
      BuildContext context, LoginAccountRequest loginAccountRequest) {
    return BlocProvider(
      create: (context) => LoginAccountBloc(),
      child: InputPasswordWidget(loginAccountRequest: loginAccountRequest),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _InputPasswordWidgetState();
  }
}

class _InputPasswordWidgetState extends State<InputPasswordWidget>
    with UIHelper {
  ProgressDialog pr;
  bool _showPassword = false;
  final _passwordController = TextEditingController();
  LoginAccountBloc _bloc;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _bloc = BlocProvider.of<LoginAccountBloc>(context);

    _passwordController.addListener(() {
      _bloc.add(PasswordChange(_passwordController.text));
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    _onLoginWithPass() {
      widget.loginAccountRequest.password = _passwordController.text.toString();
      _bloc.add(LoginWithAccount(widget.loginAccountRequest));
    }

    _onLoginWithOTP() {
      RequestPhoneNumberResponse requestPhoneNumberResponse =
          new RequestPhoneNumberResponse();
      requestPhoneNumberResponse.phoneCountryCode =
          widget.loginAccountRequest.phoneCountryCode;
      requestPhoneNumberResponse.phoneNumber =
          widget.loginAccountRequest.phoneNumber;
      requestPhoneNumberResponse.iSOCode = widget.loginAccountRequest.isoCode;

      Navigator.of(context)
          .pushNamed(RouteNamed.OTP, arguments: requestPhoneNumberResponse);
    }

    _passwordError(BaseState state) {
      if (state is LoginWithPasswordValidateError && state.error.isNotEmpty) {
        return AppLocalizations.of(context).tr(state.error);
      }
      return null;
    }

    return BlocListener<LoginAccountBloc, BaseState>(
        listener: (context, state) {
      handleCommonState(context, state);
      if (state is LoginAccountSuccess) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/Tabs", (Route<dynamic> route) => false,
            arguments: 0);
      }
    }, child:
            BlocBuilder<LoginAccountBloc, BaseState>(builder: (context, state) {
      return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
            body: Stack(children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: getLinearGradient())),
          Container(
              height: 300,
              margin: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height / 4, 20, 0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.15),
                      offset: Offset(0, 3),
                      blurRadius: 10)
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(localizedText(context, 'input_passwod'),
                        style: Theme.of(context).textTheme.headline3),
                    SizedBox(height: 10),
                    new TextField(
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2,
                      keyboardType: TextInputType.text,
                      obscureText: !_showPassword,
                      decoration: new InputDecoration(
                          hintText: AppLocalizations.of(context).tr('password'),
                          //S.of(context).password,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .merge(
                                TextStyle(color: Theme.of(context).accentColor),
                              ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Theme.of(context).hintColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Theme.of(context).hintColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Theme.of(context).hintColor),
                          ),
                          prefixIcon: Icon(
                            UiIcons.padlock_1,
                            color: Theme.of(context).accentColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            color:
                                Theme.of(context).accentColor.withOpacity(0.4),
                            icon: Icon(_showPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          errorText: _passwordError(state)),
                      controller: _passwordController,
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: _onLoginWithPass,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: getLinearGradient(),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(localizedText(context, 'login'),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .merge(TextStyle(color: Colors.white))),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          localizedText(context,'or_using_social'),
                          //S.of(context).or_using_social,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: _onLoginWithOTP,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: getLinearGradient(),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(localizedText(context, 'login_otp'),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .merge(TextStyle(color: Colors.white))),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Positioned(
              top: 30,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
//                  _scaffoldKey.currentState.openDrawer();
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              )),
        ])),
      );
    }));
  }
}
