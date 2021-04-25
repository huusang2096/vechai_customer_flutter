import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/ui_helper.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenWidget> with UIHelper {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigationPage() async {
    if (await Prefs.getToken() != "") {
      Navigator.of(context).pushNamedAndRemoveUntil(
          "/Tabs", (Route<dynamic> route) => false,
          arguments: 0);
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNamed.SIGN_IN);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Screen Util
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('img/splash_screen.png'), fit: BoxFit.cover)),
      ),
    );
  }
}
