import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/drawer_bloc.dart';
import 'package:veca_customer/src/bloc/drawer_event.dart';
import 'package:veca_customer/src/bloc/drawer_state.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';
import 'package:veca_customer/src/models/user_response.dart';

class DrawerWidget extends StatefulWidget {
  final void Function(int tabId) changeTab;

  const DrawerWidget({Key key, this.changeTab}) : super(key: key);

  static provider(BuildContext context, {void Function(int tabID) changeTab}) {
    return BlocProvider(
      create: (BuildContext context) => DrawerBloc(),
      child: DrawerWidget(changeTab: changeTab),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _DrawerWidgetState();
  }
}

class _DrawerWidgetState extends State<DrawerWidget> with UIHelper {
  Account _user;
  String _userName = "";
  String _userEmail = "";
  DrawerBloc _drawerBloc;

  @override
  void initState() {
    _drawerBloc = BlocProvider.of<DrawerBloc>(context);
    _drawerBloc.add(DrawerEventUser());
    super.initState();
  }

  _userAvatar() {
    if (_user != null && _user.avatar != null) {
      return CachedNetworkImageProvider(_user.avatar);
    } else {
      return AssetImage('img/user_placeholder.png');
    }
  }

  @override
  void dispose() {
    _drawerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerBloc, BaseState>(builder: (context, state) {
      final data = EasyLocalizationProvider.of(context).data;

      if (state is UserAccountSuccess) {
        _user = state.user;
        _userName = _user.name;
        _userEmail = _user.email;
      }

      return EasyLocalizationProvider(
        data: data,
        child: Drawer(
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  widget.changeTab(4);
                  Navigator.pop(context);
                  },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      gradient: getLinearGradient()),
                  height: 120,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            image: DecorationImage(
                                image: _userAvatar(), fit: BoxFit.cover)),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _userName,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontSize: 16).merge(TextStyle(color: Colors.white)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(_userEmail,
                              style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.white)),
                              overflow: TextOverflow.ellipsis)
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              Container(height: 1.0, color: Theme.of(context).focusColor),
              ListTile(
                onTap: () {
                  widget.changeTab(0);
                  Navigator.pop(context);
                },
                leading: Container(
                  width: 25,
                  height: 25,
                  child: Image.asset('img/home.png',
                      width: 25, color: Theme.of(context).accentColor),
                ),
                title: Text(
                  localizedText(context, "home"),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ListTile(
                onTap: () {
                  widget.changeTab(3);
                  Navigator.pop(context);
                },
                leading: Container(
                  width: 25,
                  height: 25,
                  child: Image.asset('img/history.png',
                      width: 25,color:  Theme.of(context).accentColor),
                ),
                title: Text(
                  localizedText(context, "my_orders_menu"),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ListTile(
                onTap: () {
                  widget.changeTab(1);
                  Navigator.pop(context);
                },
                leading:Container(
                  width: 25,
                  height: 25,
                  child: Image.asset('img/notification.png',
                      width: 25, color: Theme.of(context).accentColor),
                ),
                title: Text(
                  localizedText(context, "notifications"),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RouteNamed.LANGUAGES);
                },
                leading: Container(
                  width: 25,
                  height: 25,
                  child: Icon(
                    Icons.language,
                    size: 30,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                title:  Text(
                  AppLocalizations.of(context)
                      .tr('languages'),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(RouteNamed.CONTACT);
                },
                leading:  Container(
                  width: 25,
                  height: 25,
                  child: Icon(
                    Icons.phone,
                    size: 30,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                title:  Text(
                  localizedText(
                      context, 'contact'),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ListTile(
                onTap: () {
                  widget.changeTab(4);
                  Navigator.pop(context);
                },
                leading: Container(
                  width: 25,
                  height: 25,
                  child: Icon(Icons.settings,
                      color: Theme.of(context).accentColor, size: 30),
                ),
                title: Text(
                  localizedText(context, "settings"),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
                 ListTile(
                  onTap: () {
                    Prefs.clearAll();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteNamed.SIGN_IN, (Route<dynamic> route) => false);
                  },
                  leading: Container(
                    width: 25,
                    height: 25,
                    child: Image.asset('img/logout2.png',
                        width: 25, color: Theme.of(context).accentColor),
                  ),
                  title: Text(
                    localizedText(context, "log_out"),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              SizedBox(height: 80),
              ListTile(
                title: Text(
                  localizedText(context, "Version 1.0"),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
