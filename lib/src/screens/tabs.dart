import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/bloc/notifications_bloc.dart';
import 'package:veca_customer/src/bloc/notifications_event.dart';
import 'package:veca_customer/src/bloc/tabs/bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/notification.dart';
import 'package:veca_customer/src/models/token_request.dart';
import 'package:veca_customer/src/models/user_response.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/screens/base.dart';
import 'package:veca_customer/src/screens/orders.dart';
import 'package:veca_customer/src/screens/splash.dart';
import 'package:veca_customer/src/uitls/device_helper.dart';
import 'package:veca_customer/src/widgets/DrawerWidget.dart';
import 'package:flutter/services.dart';
import 'package:veca_customer/src/widgets/MarqueeWidget.dart';
import 'package:veca_customer/src/widgets/NotificationButtonWidget.dart';
import 'package:app_settings/app_settings.dart';
import 'package:veca_customer/config/app_config.dart' as config;

import 'account.dart';
import 'create_order.dart';
import 'home.dart';
import 'notification/notifications.dart';

// ignore: must_be_immutable
class TabsWidget extends StatefulWidget {
  int currentTab = 0;
  int selectedTab = 0;
  String currentTitle = 'Viet Nam';

  TabsWidget({
    Key key,
    this.currentTab,
  }) : super(key: key);

  static provider(BuildContext context, int currentTab) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotificationsBloc()),
        BlocProvider(create: (context) => OrdersBloc())
      ],
      child: TabsWidget(currentTab: currentTab),
    );
  }

  @override
  _TabsWidgetState createState() {
    return _TabsWidgetState();
  }
}

class _TabsWidgetState extends State<TabsWidget>
    with SingleTickerProviderStateMixin, UIHelper {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage;
  User _user;
  String barcode = "";
  int badges = 2;
  Position currentLocation;
  final Geolocator _locationService = Geolocator();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var serviceStatus;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  List<Widget> screens = [];

  NotificationsBloc notificationsBloc;
  OrdersBloc ordersBloc;

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _firebaseMessaging.getToken().then((token) async {
      if (token != null) {
        await Prefs.saveFCMToken(token ?? "");
        sendFCMToken();
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        var data = message['data'] ?? message;
        String jsonData = json.encode(data);

        NotificationModel notificationModel =
            NotificationModel.fromRawJson(jsonData);
        if (notificationModel.type == "logout") {
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
        } else {
          displayNotification(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  sendFCMToken() async {
    String platform = '';
    if (Platform.isIOS) {
      platform = 'ios';
    } else if (Platform.isAndroid) {
      platform = 'android';
    }
    String token = await Prefs.getFCMToken();
    if (token != null) {
      TokenRequest tokenRequest = new TokenRequest();
      tokenRequest.accountType = 1;
      tokenRequest.deviceId = await DeviceHelper.instance.getId();
      tokenRequest.platform = platform;
      tokenRequest.fcmToken = token;
      Repository.instance
          .sendFCM(tokenRequest)
          .then((value) =>
              {print("ERROR---------------------" + value.toString())})
          .catchError(
              (err) => print("ERROR---------------------" + err.toString()));
    }
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  _getUser() async {
    _user = await Prefs.getUser();
    if (_user != null) {
      setState(() {});
    }
  }

  _getBadgesCart() {
    Prefs.getBadgeCart().then((value) {
      setState(() {
        this.badges = value;
      });
    });
  }

  @override
  initState() {
    firebaseCloudMessaging_Listeners();
    sendFCMToken();
    notificationsBloc = BlocProvider.of<NotificationsBloc>(context);
    ordersBloc = BlocProvider.of<OrdersBloc>(context);
    ;

    setState(() {
      screens = [
        HomeWidget.provider(context, changeTab: (tabID) {
          _selectTab(tabID);
        }),
        NotificationsWidget.provider(context, notificationsBloc,
            changeTab: (tabID) {
          _selectTab(tabID);
        }),
        BaseScreenWidget(),
        OrdersWidget.provider(context, ordersBloc, changeTab: (tabID) {
          _selectTab(tabID);
        }),
        AccountWidget.provider(context),
      ];
    });
    _selectTab(widget.currentTab);
    _getUser();
    _getBadgesCart();
    _checkLocationService();
    super.initState();
  }

  _checkLocationService() async {
    serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    bool enabled = (serviceStatus == ServiceStatus.enabled);
    if (!enabled) {
      showCustomDialog(
          title: localizedText(context, "VECA"),
          description: localizedText(context, 'location_is_disabled'),
          buttonText: localizedText(context, 'ok'),
          image: Image.asset('img/icon_warning.png', color: Colors.white),
          context: context,
          onPress: () async {
            hasShowPopUp = false;
            serviceStatus = await Permission.locationWhenInUse.serviceStatus;
            if (serviceStatus == ServiceStatus.enabled) {
              Navigator.of(context).pop();
              getLocation();
            } else {
              AppSettings.openLocationSettings();
            }
          });
    } else {
      getLocation();
    }
  }

  getLocation() async {
    requestPermission()?.then((_) async {
      currentLocation = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(
          currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          widget.currentTitle = pos.name +
              ', ' +
              pos.thoroughfare +
              ', ' +
              pos.subAdministrativeArea +
              ', ' +
              pos.administrativeArea +
              ', ' +
              pos.country;
          print("Location" + widget.currentTitle);
        });
      }
    });
  }

  @override
  void didUpdateWidget(TabsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      widget.selectedTab = tabItem;
      switch (tabItem) {
        case 0:
          currentPage = HomeWidget.provider(context, changeTab: (tabID) {
            _selectTab(tabID);
          });
          break;
        case 1:
          currentPage = NotificationsWidget.provider(context, notificationsBloc,
              changeTab: (tabID) {
            _selectTab(tabID);
          });
          notificationsBloc.add(NotificationEvent());
          break;
        case 2:
          currentPage = BaseScreenWidget();
          break;
        case 3:
          currentPage =
              OrdersWidget.provider(context, ordersBloc, changeTab: (tabID) {
            _selectTab(tabID);
          });
          ordersBloc.add(OrderEvent("pending"));
          ordersBloc.add(OrderEvent("accepted"));
          ordersBloc.add(OrderEvent("finished"));
          break;
        case 4:
          currentPage = AccountWidget.provider(context);
          break;
      }
    });
  }

  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _userAvatar() {
      if (_user != null && _user.avatar != null) {
        return CachedNetworkImageProvider(_user.avatar);
      } else {
        return AssetImage('img/user_placeholder.png');
      }
    }

    var data = EasyLocalizationProvider.of(context).data;
    return BlocListener<TabsBloc, TabsState>(
        listener: (context, state) {},
        child: BlocBuilder<TabsBloc, TabsState>(builder: (context, state) {
          return EasyLocalizationProvider(
            data: data,
            child: WillPopScope(
              onWillPop: () {
                return _willPopCallback();
              },
              child: Scaffold(
                key: _scaffoldKey,
                drawer: DrawerWidget.provider(context, changeTab: (tabID) {
                  _selectTab(tabID);
                }),
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                        icon:
                            new Icon(Icons.menu, color: Colors.white, size: 25),
                        onPressed: () =>
                            _scaffoldKey.currentState.openDrawer()),
                    flexibleSpace: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            gradient: getLinearGradient())),
                    elevation: 0,
                    bottomOpacity: 0,
                    centerTitle: true,
                    title: Container(
                      width: 300,
                      child: MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(
                          localizedText(context, ''),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17),
                        ),
                      ),
                    )),
                body: IndexedStack(
                  index: widget.currentTab,
                  children: screens,
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(gradient: getLinearGradient()),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: widget.selectedTab,
                    backgroundColor: Colors.transparent,
                    selectedItemColor: Color(0xFFdce260),
                    unselectedItemColor: Colors.white,
                    selectedLabelStyle: Theme.of(context).textTheme.caption,
                    unselectedLabelStyle: Theme.of(context).textTheme.caption,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    elevation: 0,
                    onTap: (int i) {
                      this._selectTab(i);
                    },
                    // this will be set when a new tab is tapped
                    items: [
                      BottomNavigationBarItem(
                        icon: Image.asset('img/home.png',
                            width: 25,
                            color: widget.currentTab != 0
                                ? Colors.white
                                : Color(0xFFdce260)),
                        title: Text(
                          localizedText(context, 'home'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Image.asset('img/notification.png',
                            width: 20,
                            color: widget.currentTab != 1
                                ? Colors.white
                                : Color(0xFFdce260)),
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
                            width: 25,
                            color: widget.currentTab != 3
                                ? Colors.white
                                : Color(0xFFdce260)),
                        title: Text(
                          localizedText(context, 'my_orders_menu'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Image.asset('img/user.png',
                            width: 25,
                            color: widget.currentTab != 4
                                ? Colors.white
                                : Color(0xFFdce260)),
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
                        _pushCreateOrder();
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
                                    .merge(
                                        TextStyle(color: Color(0xFF003428)))),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          );
        }));
  }

  _pushCreateOrder() async {
    final indexTab =
        await Navigator.of(context).pushNamed(RouteNamed.CREATE_ORDER);
    if (indexTab != null) {
      _selectTab(indexTab);
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      Navigator.of(context).pushNamed(RouteNamed.CONFRIM_PAYMENT);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Fluttertoast.showToast(
        msg: "",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Fluttertoast.showToast(
                  msg: "",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
      ),
    );
  }
}
