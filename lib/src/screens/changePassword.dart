import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/changePassword/change_password_bloc.dart';
import 'package:veca_customer/src/bloc/changePassword/change_password_event.dart';
import 'package:veca_customer/src/bloc/changePassword/change_password_state.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
class ChangePasswordWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChangePasswordWidgetState();
  }
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget>
    with UIHelper {
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfrimPassword = false;

  final _oldpassController = new TextEditingController();
  final _newPassController = new TextEditingController();
  final _confrimPassController = new TextEditingController();

  ProgressDialog pr;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    _oldpassController.addListener(() {
      BlocProvider.of<ChangePasswordBloc>(context)
          .add(OldPasswordChange(oldPassword: _oldpassController.text));
    });
    _newPassController.addListener(() {
      BlocProvider.of<ChangePasswordBloc>(context)
          .add(NewPasswordChange(newPassword: _newPassController.text));
    });
    _confrimPassController.addListener(() {
      BlocProvider.of<ChangePasswordBloc>(context).add(
          ConfrimPasswordChange(confrimPassword: _confrimPassController.text));
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    _onSendChangePassword() {
      BlocProvider.of<ChangePasswordBloc>(context).add(SendNewPassword(
          oldPassword: _oldpassController.text,
          newPassword: _newPassController.text,
          confrimPassword: _confrimPassController.text));
    }

    _oldPassError(ChangePasswordState state) {
      if (state is PassWordValidateError && state.oldPasswordError.isNotEmpty) {
        return AppLocalizations.of(context).tr(state.oldPasswordError);
      }
      return null;
    }

    _newPassError(ChangePasswordState state) {
      if (state is PassWordValidateError && state.newPasswordError.isNotEmpty) {
        return AppLocalizations.of(context).tr(state.newPasswordError);
      }
      return null;
    }

    _confrimPassError(ChangePasswordState state) {
      if (state is PassWordValidateError &&
          state.confrimPasswordError.isNotEmpty) {
        return AppLocalizations.of(context).tr(state.confrimPasswordError);
      }
      return null;
    }

    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordLoading) {
            pr.show();
          }

          if (state is ChangePasswordDismiss) {
            pr.dismiss();
          }

          if (state is ChangePasswordFailure) {
            showToast(context, state.error);
          }

          if (state is ChangePassSuccess) {
            pr.dismiss();
            Navigator.pop(context);
          }
        }, child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
          return EasyLocalizationProvider(
              data: data,
              child: Scaffold(
                  backgroundColor: Theme.of(context).primaryColor,
                  body: Stack(children: <Widget>[
                    Container(height: MediaQuery.of(context).size.height/2, width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            gradient: getLinearGradient())),
                    Container(
                      height: 450,
                      margin: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height/4, 20, 0),
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
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Text(localizedText(context, 'change_pass'),textAlign: TextAlign.left,
                                      style: Theme.of(context).textTheme.headline4.merge(TextStyle(fontSize: 20, color: Theme.of(context).hintColor))),
                                  SizedBox(height: 10),
                                  new TextField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2,
                                    keyboardType: TextInputType.text,
                                    obscureText: !_showOldPassword,
                                    decoration: new InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .tr('current_password'),
                                        //S.of(context).password,
                                        hintStyle:
                                        Theme.of(context).textTheme.subtitle2.merge(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
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
                                              _showOldPassword = !_showOldPassword;
                                            });
                                          },
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.4),
                                          icon: Icon(_showOldPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                        ),
                                        errorText: _oldPassError(state)),
                                    controller: _oldpassController,
                                  ),
                                  SizedBox(height: 20),
                                  new TextField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2,
                                    keyboardType: TextInputType.text,
                                    obscureText: !_showNewPassword,
                                    decoration: new InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .tr('new_password'),
                                        //S.of(context).password,
                                        hintStyle:
                                        Theme.of(context).textTheme.subtitle2.merge(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
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
                                        hintText: AppLocalizations.of(context)
                                            .tr('password_confirmation'),
                                        //S.of(context).password,
                                        hintStyle:
                                        Theme.of(context).textTheme.subtitle2.merge(
                                          TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
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
                                        errorText: _confrimPassError(state)),
                                    controller: _confrimPassController,
                                  ),
                                  SizedBox(height: 20),

                                  GestureDetector(
                                    onTap: (){
                                      _onSendChangePassword();
                                    },
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
                                  SizedBox(height: 20)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 20.0,
                      right: 20.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 0,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100.0),
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 0,
                              child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      color:Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  ])));
        }));
  }
}
