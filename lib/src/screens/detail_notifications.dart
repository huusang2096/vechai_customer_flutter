import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/notification.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:veca_customer/config/app_config.dart' as config;

class DetailNotifications extends StatefulWidget {

  final NotificationData notification;

  DetailNotifications({this.notification});

  @override
  _DetailNotificationsState createState() => _DetailNotificationsState();

}

class _DetailNotificationsState extends State<DetailNotifications>
    with UIHelper {

  int currentTab = 1;

  _selectTab(int id) async {
    if(id == 2){
      await Navigator.of(context).pushNamed(RouteNamed.CREATE_ORDER);
      Navigator.of(context).pop(0);
    } else {
      Navigator.of(context).pop(id);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(UiIcons.return_icon, color: Theme
              .of(context)
              .primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace:   Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: getLinearGradient())),
        elevation: 0,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: Text(
          localizedText(context, 'notifications'),
          style: Theme
              .of(context)
              .textTheme
              .headline4
              .merge(TextStyle(color: Theme
              .of(context)
              .primaryColor)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Text(
                    widget.notification.title,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: null,
                  ),
                  Text(
                    widget.notification.time,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: null,
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Divider(color: Colors.black12)
                  ),],),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: HtmlWidget(
                  widget.notification.body ?? '',
                  webView: true,
                  textStyle: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 17))
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            gradient: getLinearGradient()),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentTab,
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFFdce260),
          unselectedItemColor: Colors.white,
          selectedLabelStyle: Theme.of(context).textTheme.caption,
          unselectedLabelStyle: Theme.of(context).textTheme.caption,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          onTap: (int i) {
            _selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('img/home.png',
                  width: 25, color: currentTab != 0 ? Colors.white: Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'home'),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('img/notification.png',
                  width: 20, color: currentTab != 1 ?  Colors.white :  Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'notification'),
              ),
            ),
            BottomNavigationBarItem(
                title: new Container(height: 0.0),
                icon: new Container(
                  width: 70,
                )),
            BottomNavigationBarItem(
              icon: Image.asset('img/history.png',
                  width: 25,color: currentTab != 3 ? Colors.white: Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'my_orders_menu'),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('img/user.png',
                  width: 25, color: currentTab != 4 ? Colors.white: Color(0xFFdce260)),
              title: Text(
                localizedText(context, 'profile'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          width: 80,
          height: 100,
          child: FloatingActionButton(
            onPressed: () {
              _selectTab(2);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: getLinearGradientButton(),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: Colors.white,
                    width: 2,
                    style: BorderStyle.solid),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: Text(localizedText(context, 'sell'),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .merge(TextStyle(color: Color(0xFF003428)))),
                ),
              ),
            ),
          )
      ),
    );

  }
}
