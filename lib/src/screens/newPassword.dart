import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/create_pass_account_bloc.dart';
import 'package:veca_customer/src/bloc/create_pass_account_event.dart';
import 'package:veca_customer/src/bloc/create_pass_account_state.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/LoginTokenRequest.dart';

class NewPasswordWidget extends StatefulWidget {
  String token;
  String phoneCode;
  String phoneNumber;

  NewPasswordWidget({Key key, this.token, this.phoneCode, this.phoneNumber}) {
    token = this.token;
    phoneCode = this.phoneCode;
    phoneNumber = this.phoneNumber;
  }

  static provider(BuildContext context,  String token,  String phoneCode, String phoneNumber) {
    return BlocProvider(
      create: (context) => CreatePassAccountBloc(),
      child: NewPasswordWidget(token : token, phoneCode: phoneCode, phoneNumber: phoneNumber,),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewPasswordWidgetState();
  }
}

class _NewPasswordWidgetState extends State<NewPasswordWidget> with UIHelper {
  bool _showNewPassword = false;
  bool _showConfrimPassword = false;

  final _newPassController = new TextEditingController();
  final _confrimPassController = new TextEditingController();
  CreatePassAccountBloc _bloc;
  bool isHasAccount = false;


  _getAccount() async {
    isHasAccount = await Prefs.isHasAccount();
    setState(() {
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _bloc = BlocProvider.of<CreatePassAccountBloc>(context);

    _newPassController.addListener(() {
      _bloc.add(NewPasswordChange(_newPassController.text));
    });
    _confrimPassController.addListener(() {
      _bloc.add(ConfrimPasswordChange(_confrimPassController.text));
    });
    _getAccount();
    super.initState();
  }

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    _onActionUser() {
    _bloc.add(SendNewPassword(_newPassController.text,widget.token, widget.phoneCode, widget.phoneNumber));
    }

    _newPassError(BaseState state) {
      if (state is PassWordValidateError && state.newPasswordError.isNotEmpty) {
        return AppLocalizations.of(context).tr(state.newPasswordError);
      }
      return null;
    }

    _confrimPassError(BaseState state) {
      if (state is PassWordValidateError &&
          state.confrimPasswordError.isNotEmpty) {
        return AppLocalizations.of(context).tr(state.confrimPasswordError);
      }
      return null;
    }

    _loginWithOTP(){
      LoginTokenRequest loginTokenRequest = new LoginTokenRequest();
      loginTokenRequest.otpToken = widget.token;
      loginTokenRequest.accountType = 1;
      loginTokenRequest.phoneCountryCode = widget.phoneCode;
      loginTokenRequest.phoneNumber  = widget.phoneNumber;
      _bloc.add(LoginOTPEvent(loginTokenRequest));
    }

    return BlocListener<CreatePassAccountBloc, BaseState>(
        listener: (context, state) {
          handleCommonState(context, state);
          if(state is CreateAccountState){
            if(isHasAccount){
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/Tabs", (Route<dynamic> route) => false,
                  arguments: 0);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNamed.SIGN_UP, (Route<dynamic> route) => false);
            }
          }

          if(state is LoginOTPSuccessState){
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/Tabs", (Route<dynamic> route) => false,
                arguments: 0);
          }
        },
        child: BlocBuilder<CreatePassAccountBloc, BaseState>(
            builder: (context, state) {
          return EasyLocalizationProvider(
            data: data,
            child: Scaffold(
              body: Stack(children: <Widget>[
                Container(height: MediaQuery.of(context).size.height/2, width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        gradient: getLinearGradient())),
                Container(
                    height: 430,
                    margin: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height/4, 20, 0),
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Theme
                                .of(context)
                                .hintColor
                                .withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 10)
                      ],
                    ),
                    child:  SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Text(  localizedText(context, 'update_passwod'),
                                    style: Theme.of(context).textTheme.headline3),
                                SizedBox(height: 20),
                                new TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2,
                                  keyboardType: TextInputType.text,
                                  obscureText: !_showNewPassword,
                                  decoration: new InputDecoration(
                                      hintText: localizedText(context, 'new_password'),
                                      //S.of(context).password,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .merge(
                                        TextStyle(
                                            color:
                                            Theme.of(context).accentColor),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        borderSide: BorderSide(color: Theme.of(context).hintColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        borderSide: BorderSide(color: Theme.of(context).hintColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        borderSide: BorderSide(color: Theme.of(context).hintColor),
                                      ),
                                      prefixIcon: Icon(
                                        UiIcons.padlock_1,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _showNewPassword = !_showNewPassword;
                                          });
                                        },
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.4),
                                        icon: Icon(_showNewPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      errorText: _newPassError(state)),
                                  controller: _newPassController,
                                ),
                                SizedBox(height: 20),
                                new TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2,
                                  keyboardType: TextInputType.text,
                                  obscureText: !_showConfrimPassword,
                                  decoration: new InputDecoration(
                                    hintText: localizedText(context,'password_confirmation'),
                                    //S.of(context).password,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .merge(
                                      TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                                    ),
                                    prefixIcon: Icon(
                                      UiIcons.padlock_1,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showConfrimPassword =
                                          !_showConfrimPassword;
                                        });
                                      },
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.4),
                                      icon: Icon(_showConfrimPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    errorText: _confrimPassError(state),
                                  ),
                                  controller: _confrimPassController,
                                ),
                                SizedBox(height: 40),
                                GestureDetector(
                                  onTap: _onActionUser,
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
                                        child: Text(localizedText(context, 'new_update'),textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: Theme.of(context).textTheme.headline4.merge(TextStyle(color: Colors.white))),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: InkWell(
                      onTap: _loginWithOTP,
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
                          Icons.clear,
                          color: Theme.of(context).accentColor,
                        ),
                      )),
                ),
              ],),
          ));
        }));
  }
}
