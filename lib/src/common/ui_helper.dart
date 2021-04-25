import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:html/parser.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/config/app_config.dart' as config;
import 'package:intl/intl.dart' show DateFormat;
import 'package:veca_customer/src/widgets/custom_dialog.dart';
import 'package:veca_customer/src/widgets/custom_dialog2.dart';
import 'package:veca_customer/src/widgets/momo_notification.dart';

import 'const.dart';

class UIHelper {
  PermissionStatus permissionstatus;
  var hasShowPopUp = false;
  var _isShowLoading = false;
  BuildContext _context;

  void showToast(BuildContext context, String message) {
    showCustomDialog(
        title: localizedText(context, "VECA"),
        description: message,
        buttonText: localizedText(context, 'close'),
        image: Image.asset('img/icon_warning.png', color: Colors.white),
        context: context,
        onPress: () async {
          hasShowPopUp = false;
          Navigator.of(context).pop();
        });
  }

  var isShowingLoading = false;
  showLoading({@required BuildContext context}) async {
    _context = context;
    final start = DateTime.now().millisecondsSinceEpoch;
    if (pr == null) {
      pr = ProgressDialog(context);
      pr.style(
          message: localizedText(context, "loading"),
          messageTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
              fontWeight: FontWeight.w600));
    }
    final val = await pr.show();
    final end = DateTime.now().millisecondsSinceEpoch;
    final time = end - start;
    if (!_isShowLoading) {
      return hideLoading();
    }
    return val;
    // });
  }

  hideLoading() async {
    // _loadingDeboucer.run(() {
    final start = DateTime.now().millisecondsSinceEpoch;
    var val = false;
    if (pr != null && pr.isShowing()) {
      val = await pr.hide();
      final end = DateTime.now().millisecondsSinceEpoch;
      final time = end - start;
      return val;
    }
    final end = DateTime.now().millisecondsSinceEpoch;
    final time = end - start;
    if (_isShowLoading) {
      return showLoading(context: _context);
    }
    return false;
    // });
  }

  handleCommonState(BuildContext context, BaseState state) async {
    if (state is LoadingState) {
      _isShowLoading = state.isLoading;
      if (state.isLoading) {
        return await showLoading(context: context);
      } else {
        return await hideLoading();
      }
    }

    if (state is ErrorState) {
      _isShowLoading = false;
      hideLoading();
      await Future.delayed(Duration(milliseconds: 300));
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: state.error,
          buttonText: localizedText(context, 'close'),
          image: Image.asset(
            'img/icon_warning.png',
            color: Colors.white,
          ),
          context: context,
          onPress: () {
            hasShowPopUp = false;
            Navigator.of(context).pop();
          });
    }
  }

  handleUnauthenticatedState(BuildContext context, BaseState state) async {
    if (state is UnauthenticatedState) {
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: localizedText(context, "unauthenticated"),
          buttonText: localizedText(context, 'ok'),
          image: Image.asset('img/icon_warning.png', color: Colors.white),
          context: context,
          onPress: () {
            hasShowPopUp = false;
            Prefs.clearAll();
            Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNamed.SIGN_IN, (Route<dynamic> route) => false);
          });
    }
  }

  Future<void> requestPermission() async {
    permissionstatus = await Permission.location.status;
    if (permissionstatus == PermissionStatus.granted) {
    } else if (permissionstatus == PermissionStatus.denied ||
        permissionstatus == PermissionStatus.undetermined ||
        permissionstatus == PermissionStatus.restricted) {
      await Permission.location.request();
    }
  }

  String formatTime(int dateint) {
    String date = DateFormat('dd/MM/yyyy - HH:mm')
        .format(new DateTime.fromMillisecondsSinceEpoch(dateint));
    return date;
  }

  LinearGradient getLinearGradient() {
    return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          config.Colors().mainDarkColor(1),
          config.Colors().mainColor(1),
        ]);
  }

  LinearGradient getLinearGradientButton() {
    return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFdce260),
          Color(0xFF39b64a),
        ]);
  }

  ProgressDialog pr;
  Completer<void> refreshCompleter;

  intUI() {
    refreshCompleter = Completer<void>();
  }

  String localizedText(BuildContext context, String key, {dynamic args}) {
    return AppLocalizations.of(context).tr(key, args: args);
  }

  BoxDecoration getBoxDecoration(BuildContext context) {
    return new BoxDecoration(
      color: Colors.white,
      border:
          Border.all(color: Colors.black12, width: 0, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      boxShadow: [
        BoxShadow(
            color: Theme.of(context).primaryColor,
            offset: Offset(0, 3),
            blurRadius: 6,
            spreadRadius: 1)
      ],
    );
  }

  hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static String skipHtml(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  showCustomDialog(
      {BuildContext context,
      String title,
      String description,
      String buttonText,
      Image image,
      Function onPress}) {
    if (hasShowPopUp) {
      return;
    }
    hasShowPopUp = true;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CustomDialog(
              title: localizedText(context, title),
              description: localizedText(context, description),
              buttonText: buttonText,
              image: image,
              onPress: onPress,
            ));
  }

  loadingPager(BuildContext context, double heightScreen) {
    return Container(
        height: heightScreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ));
  }

  showCustomDialog2(
      {BuildContext context,
      String title,
      String description,
      String buttonText,
      String buttonClose,
      Image image,
      Function onPress}) {
    if (hasShowPopUp) {
      return;
    }
    hasShowPopUp = true;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CustomDialog2(
              title: localizedText(context, title),
              description: localizedText(context, description),
              buttonText: buttonText,
              buttonClose: buttonClose,
              image: image,
              onPress: onPress,
              onClose: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              },
            ));
  }

  momoNotificaiton({BuildContext context, Image image, Function onPress}) {
    if (hasShowPopUp) {
      return;
    }
    hasShowPopUp = true;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => MomoNotification(
              image: image,
              onClose: () {
                hasShowPopUp = false;
                Navigator.of(context).pop();
              },
            ));
  }
}
