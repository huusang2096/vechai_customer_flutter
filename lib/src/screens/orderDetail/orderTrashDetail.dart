import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/AddressResponse.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/widgets/line_dash.dart';
import 'package:veca_customer/config/app_config.dart' as config;


class OrderTrashDetailWidget extends StatefulWidget {
  OrderModel order;

  OrderTrashDetailWidget(this.order);

  @override
  _OrderTrashDetaiState createState() => _OrderTrashDetaiState();

}

class _OrderTrashDetaiState extends State<OrderTrashDetailWidget>
    with UIHelper {
  final String screenName = "HOME";
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;
  BitmapDescriptor markerIcon;
  GoogleMapController _mapController;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  int _markerIdCounter = 0;
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;
  double latitude, longitude;

  @override
  void initState() {
    super.initState();
    latitude = widget.order.address.lLat;
    longitude = widget.order.address.lLong;
    fetchLocation();
  }


  void fetchLocation() {
      moveCameraToMyLocation();
  }

  void moveCameraToMyLocation() {
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(
       latitude,longitude);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
    );
    setState(() {
      _markers[markerId] = marker;
    });
    Future.delayed(Duration(milliseconds: 200), () async {
      _mapController = controller;
      controller?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    int currentTab = 3;

    _selectTab(int id) async {
      if(id == 2){
        await Navigator.of(context).pushNamed(RouteNamed.CREATE_ORDER);
        Navigator.of(context).pop(0);
      } else {
        Navigator.of(context).pop(id);
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          localizedText(context, 'order_detail'),
          style: Theme.of(context)
              .textTheme
              .headline4
              .merge(TextStyle(color: Theme.of(context).primaryColor)),
        ),
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
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  localizedText(context, "order_detail"),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.date_range,
                      size: 25,
                      color: Theme.of(context).accentColor,
                    ),
                    contentPadding: EdgeInsets.only(
                        top: 0.0, bottom: 0.0, right: 10.0, left: 10.0),
                    title: Text(localizedText(context, 'date_create_order'),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        widget.order.requestTime == 1 ? Text(
                         localizedText(context, 'officeHours'),
                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).accentColor)),
                        ) : Text(
                          localizedText(context, 'weekend'),
                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).accentColor)),
                        ),
                        Text(
                          formatTime(widget.order.createdAt),
                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).accentColor)),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.report,
                      size: 25,
                      color: Theme.of(context).accentColor,
                    ),
                    contentPadding: EdgeInsets.only(
                        top: 0.0, bottom: 0.0, right: 10.0, left: 10.0),
                    title: Text(localizedText(context, "order_status"),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left),
                    trailing: Text(
                      localizedText(context,  widget.order.status),
                      style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).accentColor)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              LineDash(color: Colors.grey),
              SizedBox(height: 5),
              ListTile(
                title: Text(
                  localizedText(context, 'address_order'),
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              ListTile(
                onTap: () {},
                leading: Image.asset('img/icon_address.png',
                    color: Theme.of(context).accentColor, width: 40),
                title: Text(widget.order.address.addressTitle,
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.left),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.order.address.addressDescription != "ghichu" ? Text( widget.order.address.addressDescription,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.left,
                        maxLines: null): SizedBox.shrink(),
                    Text(
                        widget.order.address.localName,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.left,
                        maxLines: null)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ],
                ),
                child: GoogleMap(
                  markers: Set<Marker>.of(_markers.values),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        latitude, longitude),
                    zoom: 12.0,
                  ),
                ),
              ),
            ],
          )),
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
