import 'dart:async';
import 'dart:ui';

import 'package:devicelocale/devicelocale.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/config/app_config.dart' as config;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:veca_customer/src/common/bloc_delegate.dart';
import 'package:veca_customer/route_generator.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/uitls/device_helper.dart';
import 'package:veca_customer/src/widgets/StatefulWrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(EasyLocalization(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer _timerLink;
  final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();
  static const stream = const EventChannel('appstore.dynamiclink/events');
  String _languageCode; // Default en

  @override
  void initState() {
    super.initState();
    // Languages
    Prefs.getLanguages().then((languageCode) {
      this._languageCode = languageCode;
      Const.defaultLanguage = languageCode ?? 'vi';
    }).whenComplete(() {
      Devicelocale.currentLocale.then((value) {
        if (_languageCode == null) {
          final currentLanguageCode = "vi";
          Prefs.saveLanguages(currentLanguageCode);
          if (currentLanguageCode.contains('vi')) {
            EasyLocalizationProvider.of(context)
                .data
                .changeLocale(Locale('vi', 'VN'));
          } else {
            EasyLocalizationProvider.of(context)
                .data
                .changeLocale(Locale('en', 'US'));
          }
        } else {
          if (_languageCode == 'vi') {
            EasyLocalizationProvider.of(context)
                .data
                .changeLocale(Locale('vi', 'VN'));
          } else if (_languageCode == 'en') {
            EasyLocalizationProvider.of(context)
                .data
                .changeLocale(Locale('en', 'US'));
          }
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceHelper.instance.setContext(context);
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: StatefulWrapper(
        onInit: () {
          Prefs.setIsAskedVersion(false);
        },
        child: MaterialApp(
          title: 'VecaCustomer',
          navigatorKey: _navigatorKey,
          onGenerateRoute: RouteGenerator.generateRoute,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            //app-specific localization
            EasyLocalizationDelegate(locale: data.locale, path: 'assets/langs'),
          ],
          supportedLocales: [Locale('vi', 'VN'), Locale('en', 'US')],
          locale: data.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.white,
            brightness: Brightness.light,
            accentColor: config.Colors().mainColor(1),
            focusColor: config.Colors().accentColor(1),
            hintColor: config.Colors().secondColor(1),
            textSelectionColor: config.Colors().secondColor(1),
            textSelectionHandleColor: config.Colors().categoryColor(1),
            textTheme: TextTheme(
              button: TextStyle(fontFamily: 'LatoBold', color: Colors.white),
              headline5: TextStyle(
                  fontFamily: 'LatoBold',
                  fontSize: 20.0,
                  color: config.Colors().secondColor(1)),
              headline4: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'LatoBold',
                  color: config.Colors().secondColor(1)),
              headline3: TextStyle(
                  fontSize: 19.0,
                  fontFamily: 'LatoBold',
                  color: config.Colors().secondColor(1)),
              headline2: TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'LatoBold',
                  color: config.Colors().mainColor(1)),
              headline1: TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'LatoBold',
                  color: config.Colors().secondColor(1)),
              headline6: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'LatoBold',
                  color: config.Colors().mainColor(1)),
              subtitle1: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'LatoBold',
                  color: config.Colors().secondColor(1)),
              subtitle2: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'LatoMedium',
                  color: config.Colors().secondColor(1)),
              bodyText2: TextStyle(
                  fontFamily: 'LatoRegular',
                  fontSize: 14.0,
                  color: config.Colors().secondColor(1)),
              bodyText1: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'LatoBold',
                  color: config.Colors().secondColor(1)),
              caption: TextStyle(
                  fontFamily: 'LatoRegular',
                  fontSize: 12.0,
                  color: config.Colors().secondColor(0.6)),
            ),
          ),
        ),
      ),
    );
  }
}
