import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/ui_helper.dart';

class BaseScreenWidget extends StatefulWidget {
  @override
  _BaseScreenWidgetState createState() => _BaseScreenWidgetState();
}

class _BaseScreenWidgetState extends State<BaseScreenWidget> with UIHelper {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Screen Util
    return new Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Image.asset('img/background.png', fit: BoxFit.cover),
      ),
    ));
  }
}
