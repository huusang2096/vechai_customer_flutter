import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/RequestPhoneNumberResponse.dart';
class OtpWidget extends StatefulWidget {
  RequestPhoneNumberResponse requestPhoneNumberResponse;

  OtpWidget({Key key, this.requestPhoneNumberResponse}) {
    requestPhoneNumberResponse = this.requestPhoneNumberResponse;
  }

  static provider(BuildContext context,  RequestPhoneNumberResponse requestPhoneNumberResponse) {
    return BlocProvider(
      create: (context) => OtpBloc(),
      child: OtpWidget(requestPhoneNumberResponse : requestPhoneNumberResponse),
    );
  }

  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<OtpWidget>
    with SingleTickerProviderStateMixin, UIHelper {
  // Constants
  final int time = 30;
  AnimationController _controller;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;
  int _fiveDigit;
  int _sixDigit;

  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton = true;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  OtpBloc _bloc;

  // Overridden methods
  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: Duration(seconds: time))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _hideResendButton = !_hideResendButton;
          });
        }
      });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _bloc = BlocProvider.of<OtpBloc>(context);
    _bloc.add(SendOTPEvent(widget.requestPhoneNumberResponse));
    _autoverify();
  }

  _autoverify(){
    _bloc.phoneAuth.onSignSuccess = (user) async {
      if (user != null && user is FirebaseUser) {
        String verify_token = (await user.getIdToken()).token;
      print("TOKEN VERIFY" + verify_token);
      Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNamed.NEW_PASS, (Route<dynamic> route) => false,
      arguments: {"token": verify_token,
      "code": widget.requestPhoneNumberResponse.phoneCountryCode , "phonenumber" : widget.requestPhoneNumberResponse.phoneNumber});
      } else {
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: localizedText(context,'phone_verification_failed'),
          buttonText: localizedText(context, 'close'),
          image: Image.asset(
              'img/icon_warning.png', color: Colors.white),
          context: context,
          onPress: () async {
            hasShowPopUp = false;
            Navigator.of(context).pop();
          });
      }
    };

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return BlocListener<OtpBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
      if(state is SendOTPSuccessState){
        _startCountdown();
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: localizedText(context, state.message),
            buttonText: localizedText(context, 'close'),
            image: Image.asset(
                'img/icon_success.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
      }

    }, child: BlocBuilder<OtpBloc, BaseState>(builder: (context, state) {
      return  Scaffold(
        appBar: _getAppbar,
        backgroundColor: Colors.white,
        body: new Container(
          width: _screenSize.width,
          child: _getInputPart,
        ),
      );
    }));
  }

  // Returns "Appbar"
  get _getAppbar {
    return new AppBar(
      leading: new IconButton(
        icon: new Icon(UiIcons.return_icon,
            color: Theme.of(context).primaryColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace:   Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              gradient: getLinearGradient())),
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      title: Text(
        localizedText(context, 'verification_code'),
        style: Theme.of(context)
            .textTheme
            .headline4
            .merge(TextStyle(color: Theme.of(context).primaryColor)),),
      actions: <Widget>[
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                localizedText(context, 'skip'),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .merge(TextStyle(color: Theme.of(context).accentColor)),
              ),
            ),
          ),
        )
      ],
    );
  }

  // Return "Email" label
  get _getEmailLabel {
    return new Text(
      localizedText(context, 'enter_otp'),
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headline4
          .merge(TextStyle(color: Theme.of(context).primaryColor)),
    );
  }

  // Return "OTP" input field
  get _getInputField {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fiveDigit),
        _otpTextField(_sixDigit),
      ],
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Stack(children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height / 3,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: getLinearGradient()),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(child: Column(children: <Widget>[
                    _getEmailLabel,
                    SizedBox(height: 20),
                  ],),),
                  _getInputField,
                ],
              )),
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height/4 + 10, 0, 0),
              child: _hideResendButton ? _getTimerText : _getResendButton,),
          )
        ],),
        _getOtpKeyboard,
      ],
    );
  }

  // Returns "Timer" label
  get _getTimerText {
    return Container(
      width: 80,
      height: 80,
      child: new Offstage(
        offstage: !_hideResendButton,
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
                child: OtpTimer(_controller, 15.0, Colors.white)
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Resend" button
  get _getResendButton {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: _startCountdown,
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
              child: Text(localizedText(context, 'resend'),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .merge(TextStyle(color: Colors.white))),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return new Container(
        height: MediaQuery.of(context).size.height * (1/2) - 20,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: new Icon(
                        Icons.backspace,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_sixDigit != null) {
                            _sixDigit = null;
                          } else if (_fiveDigit != null) {
                            _fiveDigit = null;
                          } else if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return new Container(
        width: 50.0,
        height: 50.0,
        alignment: Alignment.center,
        child: new Text(
          digit != null ? digit.toString() : ".",
          style: Theme.of(context).textTheme.bodyText2.merge(
              TextStyle(color: Theme.of(context).hintColor, fontSize: 25)),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ));
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          height: MediaQuery.of(context).size.height * (1/10),
          width: MediaQuery.of(context).size.width * (1/4),
          decoration: new BoxDecoration(
            color: Color(0xFFeef3f9),
            shape: BoxShape.rectangle,
          ),
          child: new Center(
            child: new Text(label,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .merge(TextStyle(color: Color(0xFF607d8b), fontSize: 25.0)),
                ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;
      } else if (_fiveDigit == null) {
        _fiveDigit = _currentDigit;
      } else if (_sixDigit == null) {
        _sixDigit = _currentDigit;

        var otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString() +
            _fiveDigit.toString() +
            _sixDigit.toString();

        _submitVerify(otp);
      }
    });
  }

  _submitVerify(String otp) async {
    final user = await _bloc.phoneAuth.signInWithPhoneNumber(otp);
    if (user != null && user is FirebaseUser) {
      String verify_token = (await user.getIdToken()).token;
      print("TOKEN VERIFY" + verify_token);
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNamed.NEW_PASS, (Route<dynamic> route) => false,
          arguments: {"token": verify_token,
            "code": widget.requestPhoneNumberResponse.phoneCountryCode , "phonenumber" : widget.requestPhoneNumberResponse.phoneNumber});
    } else {
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: localizedText(context,'phone_verification_failed'),
          buttonText: localizedText(context, 'ok'),
          image: Image.asset(
              'img/phone.png',color: Colors.white),
          context: context,
          onPress: () async {
            hasShowPopUp = false;
            Navigator.of(context).pop();
          });
    }
  }

  Future<Null> _startCountdown() async {
    setState(() {
      clearOtp();
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void clearOtp() {
    _sixDigit = null;
    _fiveDigit = null;
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return new Text(
            timerString,
            style: Theme.of(context)
                .textTheme
                .headline4
                .merge(TextStyle(color: Colors.white)),
          );
        });
  }
}
