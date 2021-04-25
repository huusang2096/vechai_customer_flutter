import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/models/AddressModel.dart';
import 'package:veca_customer/src/models/AddressRequest.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/bloc/map/place_bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/place_model.dart';
import 'package:veca_customer/src/widgets/MarqueeWidget.dart';
import 'package:veca_customer/config/app_config.dart' as config;

class SelectMapWidget extends StatefulWidget {
  static provider(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceAddressBloc(),
      child: SelectMapWidget(),
    );
  }

  @override
  _SelectMapWidgetState createState() => _SelectMapWidgetState();
}

class _SelectMapWidgetState extends State<SelectMapWidget>
    with UIHelper, SingleTickerProviderStateMixin {
  final String screenName = "HOME";
  PlaceAddressBloc _bloc;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Repository repository = Repository.instance;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;
  // int _markerIdCounter = 0;
  GoogleMapController _mapController;
  BitmapDescriptor markerIcon;
  GoogleMapController mapController;
  CameraPosition _position;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  bool _obscureText = false;

  Position currentLocation;
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;
  final _addressNameController = TextEditingController();
  final _addressLocaNameController = TextEditingController();
  final _addressdescController = TextEditingController();
  double lat, lng;

  String district = "";
  bool isShowOrder = false;
  String city = "";
  var serviceStatus;
  bool isMove = true;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PlaceAddressBloc>(context);
    _tabController = TabController(vsync: this, length: 3);
    _checkLocationService();
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
              _initCurrentLocation();
            } else {
              AppSettings.openLocationSettings();
            }
          });
    } else {
      _initCurrentLocation();
    }
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    currentLocation = await _locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(
        currentLocation?.latitude, currentLocation?.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        district = pos.subAdministrativeArea;
        city = pos.administrativeArea;
        _addressLocaNameController.text = pos.name +
            ', ' +
            pos.thoroughfare +
            ', ' +
            pos.subAdministrativeArea +
            ', ' +
            pos.administrativeArea +
            ', ' +
            pos.country;
        lat = currentLocation.latitude;
        lng = currentLocation.longitude;
      });
    }
    if (currentLocation != null) {
      moveCameraToMyLocation();
    }
  }

  void moveCameraToMyLocation() {
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  _searchAddress() {
    var callBack = (place) {
      Place placeHouse = place;
      getLocationName(
          placeHouse.lat, placeHouse.lng, placeHouse.formattedAddress);
    };
    Navigator.of(context)
        .pushNamed(RouteNamed.SEARCH_ADDRESS, arguments: callBack);
  }

  void cameraUpdate(double lat, double lng) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: 14.4746,
    )));
    Future.delayed(Duration(milliseconds: 2000), () async {
      isMove = true;
    });
  }

  /// Get current location name
  void getLocationName(double lat, double lng, String name) async {
    isMove = false;
    if (lat != null && lng != null) {
      setState(() {
        _addressLocaNameController.text = name;
        this.lat = lat;
        this.lng = lng;
      });
      cameraUpdate(lat, lng);
    }
  }

  void locationMove(double lat, double lng) async {
    if (lat != null && lng != null && isMove) {
      List<Placemark> placemarks =
          await Geolocator()?.placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          district = pos.subAdministrativeArea;
          city = pos.administrativeArea;
          _addressLocaNameController.text = pos.name +
              ', ' +
              pos.thoroughfare +
              ', ' +
              pos.subAdministrativeArea +
              ', ' +
              pos.administrativeArea +
              ', ' +
              pos.country;
          this.lat = lat;
          this.lng = lng;
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    // MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(
        currentLocation != null ? currentLocation?.latitude : 10.767843,
        currentLocation != null ? currentLocation?.longitude : 106.674354);
    // Marker marker = Marker(
    //   markerId: markerId,
    //   position: position,
    //   draggable: false,
    // );
    // _markers[markerId] = marker;
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

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      nightMode = true;
      _mapController.setMapStyle(mapStyle);
    });
  }

  void changeMapType(int id, String fileName) {
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName)?.then(_setMapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlaceAddressBloc, BaseState>(
        listener: (context, state) {
      handleCommonState(context, state);
      if (state is UploadAddressSuccessState) {
        Navigator.of(context).pop(state.addressModel.id);
      }
    }, child:
            BlocBuilder<PlaceAddressBloc, BaseState>(builder: (context, state) {
      if (_tabController.index == 0) {
        _addressNameController.text = localizedText(context, 'house');
      }
      return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _mapsWidget(),
            _topSearchWidget(context),
            _detailLocationWidget(context),
            _myLocationWidget(context),
            Center(
              child: Icon(
                Icons.location_on,
                size: 40,
                color: Colors.red,
              ),
            )
          ],
        ),
      );
    }));
  }

  Positioned _myLocationWidget(BuildContext context) {
    return Positioned(
        bottom: 280,
        right: 20,
        child: GestureDetector(
          onTap: () {
            _initCurrentLocation();
          },
          child: Container(
            height: 60.0,
            width: 60.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(100.0),
              ),
            ),
            child: Icon(
              Icons.my_location,
              size: 20.0,
              color: Theme.of(context).accentColor,
            ),
          ),
        ));
  }

  Positioned _detailLocationWidget(BuildContext context) {
    return Positioned(
      bottom: 30.0,
      left: 20.0,
      right: 20.0,
      child: Container(
          height: 230.0,
          child: Material(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: config.Colors().mainDarkColor(1),
                              width: 0.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: TabBar(
                        indicatorColor: Colors.transparent,
                        indicator: BoxDecoration(
                          gradient: getLinearGradient(),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 15)
                          ],
                        ),
                        indicatorWeight: 0.0,
                        unselectedLabelColor: config.Colors().secondColor(1),
                        labelColor: Colors.white,
                        labelStyle: Theme.of(context).textTheme.subtitle2,
                        unselectedLabelStyle:
                            Theme.of(context).textTheme.subtitle2,
                        isScrollable: false,
                        controller: _tabController,
                        onTap: (id) {
                          if (id == 0) {
                            setState(() {
                              isShowOrder = false;
                            });
                            _addressNameController.text =
                                localizedText(context, 'house');
                          } else if (id == 1) {
                            setState(() {
                              isShowOrder = false;
                            });
                            _addressNameController.text =
                                localizedText(context, 'organization');
                          } else {
                            setState(() {
                              isShowOrder = true;
                            });
                            _addressNameController.text = "";
                          }
                        },
                        tabs: <Widget>[
                          Tab(
                            child: Text(
                              localizedText(context, 'house'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Tab(
                            child: Text(
                              localizedText(context, 'organization'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Tab(
                            child: Text(
                              localizedText(context, 'orther'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    new TextField(
                      enabled: isShowOrder,
                      style: Theme.of(context).textTheme.bodyText2,
                      keyboardType: TextInputType.text,
                      controller: _addressNameController,
                      decoration: new InputDecoration(
                        errorText: null,
                        hintText: localizedText(context, 'name_address'),
                        hintStyle: Theme.of(context).textTheme.subtitle2.merge(
                              TextStyle(color: Theme.of(context).accentColor),
                            ),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                        prefixIcon: Icon(
                          Icons.home,
                          size: 25,
                          color: Theme.of(context).accentColor,
                        ),
                        contentPadding: EdgeInsets.only(top: 18),
                      ),
                    ),
                    new TextField(
                      style: Theme.of(context).textTheme.bodyText2,
                      keyboardType: TextInputType.text,
                      controller: _addressdescController,
                      decoration: new InputDecoration(
                        errorText: null,
                        hintText: localizedText(context, 'desc_address'),
                        hintStyle: Theme.of(context).textTheme.subtitle2.merge(
                              TextStyle(color: Theme.of(context).accentColor),
                            ),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor)),
                        prefixIcon: Icon(
                          Icons.business,
                          size: 25,
                          color: Theme.of(context).accentColor,
                        ),
                        contentPadding: EdgeInsets.only(top: 18),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: getLinearGradient(),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 15)
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_addressNameController.text.toString().isEmpty) {
                            showToast(
                                context,
                                localizedText(
                                    context, 'name_address_is_empty'));
                          } else {
                            AddressRequest addressModel = new AddressRequest();
                            addressModel.lLat = lat;
                            addressModel.lLong = lng;
                            addressModel.localName =
                                _addressLocaNameController.text;
                            addressModel.city = city;
                            addressModel.district = district;
                            addressModel.addressTitle =
                                _addressNameController.text.toString();
                            addressModel.addressDescription =
                                _addressdescController.text.toString().isEmpty
                                    ? "ghichu"
                                    : _addressdescController.text.toString();
                            _bloc.add(UploadAddress(addressModel));
                          }
                        },
                        child: Center(
                          child: Text(
                            localizedText(context, 'choose_address'),
                            style: Theme.of(context).textTheme.headline4.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          )),
    );
  }

  Positioned _topSearchWidget(BuildContext context) {
    return Positioned(
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
                  color: Colors.white,
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
            child: Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                _searchAddress();
                              },
                              child: TextFormField(
                                  enabled: _obscureText,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  keyboardType: TextInputType.text,
                                  controller: _addressLocaNameController,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      border: InputBorder.none))),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText ? Icons.done : Icons.edit,
                            color: Theme.of(context).accentColor,
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _mapsWidget() {
    return SizedBox(
      //height: MediaQuery.of(context).size.height - 180,
      child: GoogleMap(
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              currentLocation != null ? currentLocation?.latitude : 10.767843,
              currentLocation != null
                  ? currentLocation?.longitude
                  : 106.674354),
          zoom: 12.0,
        ),
        onCameraMove: (CameraPosition position) {
          /* if (_markers.length > 0) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker marker = _markers[markerId];
                  Marker updatedMarker = marker?.copyWith(
                    positionParam: position?.target,
                  );
                  setState(() {
                    _markers[markerId] = updatedMarker;
                    _position = position;
                  });
                } */
        },
        onCameraIdle: _onCameraIdle,
      ),
    );
  }

  _onCameraIdle() async {
    final size = MediaQuery.of(context).size;
    final deviceRatio = MediaQuery.of(context).devicePixelRatio;
    final isAndroid = Platform.isAndroid;
    final width = isAndroid ? size.width * deviceRatio : size.width;
    final height = isAndroid ? size.height * deviceRatio : size.height;
    final screenCoordinate = ScreenCoordinate(x: width ~/ 2, y: height ~/ 2.0);
    final centerLatLng = await _mapController.getLatLng(screenCoordinate);
    locationMove(centerLatLng.latitude, centerLatLng.longitude);
    // _bloc.add(MainUpdateFromPositionEvent(centerLatLng));
    // locationMove(
    //     _position?.target?.latitude != null
    //         ? _position?.target?.latitude
    //         : currentLocation?.latitude,
    //     _position?.target?.longitude != null
    //         ? _position?.target?.longitude
    //         : currentLocation?.longitude);
  }
}
