import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/Enum.dart';
import 'package:veca_customer/config/app_config.dart' as config;
import 'package:veca_customer/src/models/AddressModel.dart';

class CreateOrderWidget extends StatefulWidget {
  final void Function(int tabId) changeTab;

  CreateOrderWidget(this.changeTab);

  @override
  _CreateOrderState createState() => _CreateOrderState();

  static provider(BuildContext context, {void Function(int tabID) changeTab}) {
    return BlocProvider(
      create: (context) => SellBloc(),
      child: CreateOrderWidget(changeTab),
    );
  }
}

class _CreateOrderState extends State<CreateOrderWidget> with UIHelper {
  final String screenName = "HOME";

  CircleId selectedCircle;
  BitmapDescriptor markerIcon;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;

  Position currentLocation;
  PermissionStatus permission;
  OrderHours orderHours;
  List<AddressModel> addressModels = [];
  AddressModel addressModelSelect;
  SellBloc _bloc;
  String locationName = "Home";
  String district = "";
  String city = "";

  @override
  void initState() {
    super.initState();
    getLocation();
    _bloc = BlocProvider.of<SellBloc>(context);
    _bloc.add(GetAddressEvent());
  }

  _addAddress() async {
    Navigator.of(context)
        .pushNamed(RouteNamed.ADDRESS_MAP).then((value) => {
      if(value != null){
        _bloc.selectAddressId = value,
        _bloc.add(GetAddressEvent()),
      }
    });
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    getLocation();
    return null;
  }

  getLocation() async {
    requestPermission()?.then((_) async {
      currentLocation = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(
          currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        district = pos.subAdministrativeArea;
        city = pos.administrativeArea;
        setState(() {
          locationName = pos.name +
              ', ' +
              pos.thoroughfare +
              ', ' +
              pos.subAdministrativeArea +
              ', ' +
              pos.administrativeArea +
              ', ' +
              pos.country;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellBloc, BaseState>(listener: (context, state) {
      handleCommonState(context, state);
      handleUnauthenticatedState(context, state);
      if (state is AddressList) {
        addressModels = state.data;
      }

      if (state is CreateSellSuccess) {
        showCustomDialog(
            title: localizedText(context, "VECA"),
            description: localizedText(context, 'create_order_success'),
            buttonText: localizedText(context, 'close'),
            image: Image.asset(
                'img/icon_success.png', color: Colors.white),
            context: context,
            onPress: () {
              hasShowPopUp = false;
              Navigator.of(context).pop();
            });
        orderHours = null;
      }
    }, child: BlocBuilder<SellBloc, BaseState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: new IconButton(
                icon: new Icon(UiIcons.return_icon, color: Theme
                    .of(context)
                    .primaryColor),
                onPressed: () =>
                {
                  Navigator.of(context).pop(0)
                }
            ),
            flexibleSpace: Container(
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    gradient: getLinearGradient())),
            elevation: 0,
            iconTheme: IconThemeData(color: Theme
                .of(context)
                .primaryColor),
            title: Text(
              localizedText(context, 'sell'),
              style: Theme
                  .of(context)
                  .textTheme
                  .headline4
                  .merge(TextStyle(color: Theme
                  .of(context)
                  .primaryColor)),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        localizedText(context, 'create_order_scarp'),
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline4
                    ),
                    Text(
                        localizedText(context,
                            'choose_the_location_and_time_of_purchase'),
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText2
                            .merge(TextStyle(color: config.Colors()
                            .accentDarkColor(1)))
                    ),
                    SizedBox(height: 25),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: [ Image.asset('img/location_home.png',
                            color: Theme
                                .of(context)
                                .accentColor, width: 30),
                          SizedBox(width: 10),
                          Text(
                            localizedText(
                                context, 'address_profile'),
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline4,
                          ),
                        ],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * (1 / 4),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                gradient: getLinearGradient(),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                      Theme
                                          .of(context)
                                          .hintColor
                                          .withOpacity(0.15),
                                      offset: Offset(0, 3),
                                      blurRadius: 15)
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  _addAddress();
                                },
                                child: Center(
                                  child: Text(
                                    localizedText(context, 'add'),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline4
                                        .merge(
                                      TextStyle(
                                          color: Theme
                                              .of(context)
                                              .primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],),
                      ],
                    ),
                    SizedBox(height: 10),
                    addressModels.length != 0 ? Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFe3e3e3),
                        border: Border.all(color: Color(0xFF999998),
                            width: 0.5),
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                              color: Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 15)
                        ],
                      ),
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return ItemTile(
                            item: addressModels[index],
                            onSelectAddress: (address) {
                              _bloc.add(SelectAddress(id: address.id));
                            },
                            onDeletePressed: (addressId) {
                              _bloc.add(DeleteAddress(id: addressId));
                            },
                          );
                        },
                        itemCount: addressModels.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),
                    ) : SizedBox.shrink(),
                    SizedBox(height: 25),
                    Row(
                      children: <Widget>[
                        Image.asset('img/time.png',
                            color: Theme
                                .of(context)
                                .accentColor, width: 30),
                        SizedBox(width: 10),
                        Text(
                          localizedText(
                              context, 'collector_date'),
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline4,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        decoration: BoxDecoration(
                          color: Color(0xFFe3e3e3),
                          border: Border.all(color: Color(0xFF999998),
                              width: 0.5),
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                                color: Theme
                                    .of(context)
                                    .hintColor
                                    .withOpacity(0.15),
                                offset: Offset(0, 3),
                                blurRadius: 15)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          orderHours = OrderHours.officeHours;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: orderHours !=
                                              OrderHours.officeHours ? Colors
                                              .white : null,
                                          border: orderHours !=
                                              OrderHours.officeHours ? Border
                                              .all(color: Color(0xFF999998),
                                              width: 0.5) : null,
                                          gradient: orderHours ==
                                              OrderHours.officeHours
                                              ? getLinearGradient()
                                              : null,
                                          borderRadius: BorderRadius.circular(
                                              15.0),
                                        ),
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * (1 / 2),
                                        child: Text(
                                            localizedText(
                                                context, 'officeHours'),
                                            textAlign: TextAlign.center,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .bodyText1
                                                .merge(TextStyle(
                                                color: orderHours ==
                                                    OrderHours.officeHours
                                                    ? Colors.white
                                                    : config.Colors()
                                                    .secondDarkColor(1)))),
                                      ),)),
                                SizedBox(width: 20),
                                Flexible(
                                    flex: 1,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            orderHours = OrderHours.weekend;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: orderHours !=
                                                OrderHours.weekend ? Colors
                                                .white : null,
                                            border: orderHours !=
                                                OrderHours.weekend ? Border.all(
                                                color: Color(0xFF999998),
                                                width: 0.5) : null,
                                            gradient: orderHours ==
                                                OrderHours.weekend
                                                ? getLinearGradient()
                                                : null,
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          padding: const EdgeInsets.all(10.0),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * (1 / 2),
                                          child: Text(
                                              localizedText(
                                                  context, 'weekend'),
                                              textAlign: TextAlign.center,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(TextStyle(
                                                  color: orderHours ==
                                                      OrderHours.weekend
                                                      ? Colors.white
                                                      : config.Colors()
                                                      .secondDarkColor(1)))),
                                        )))
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(children: [
                              Text(localizedText(
                                  context, 'time_provider_collect'),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .subtitle2),
                              SizedBox(width: 10),
                              Text("08:00 - 17:00",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(
                                      TextStyle(color: Color(0xFF0068d0)))),
                            ],)
                          ],)
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: getLinearGradient(),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color:
                              Theme
                                  .of(context)
                                  .hintColor
                                  .withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 15)
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          _bloc.add(CreateSell(orderHours));
                        },
                        child: Center(
                          child: Text(
                            localizedText(context, 'finish_order'),
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline4
                                .merge(
                              TextStyle(
                                  color: Theme
                                      .of(context)
                                      .primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                )),
          )
      );
    }));
  }
}

class ItemTile extends StatelessWidget {
  final AddressModel item;
  final Function(AddressModel) onSelectAddress;
  final Function(int) onDeletePressed;

  const ItemTile(
      {Key key, @required this.item, @required this.onSelectAddress, @required this.onDeletePressed,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LinearGradient getLinearGradient() {
      return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            config.Colors().mainDarkColor(1),
            config.Colors().mainColor(1),
          ]);
    }

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: !item.isSelect ? Colors.white : null,
            border: !item.isSelect ? Border.all(
                color: Color(0xFF999998), width: 0.5) : null,
            gradient: item.isSelect
                ? getLinearGradient()
                : null,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            onTap: () {
              onSelectAddress(item);
            },
            title: Text(item.addressTitle,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1
                    .merge(TextStyle(
                    color: item.isSelect ? Colors.white : config.Colors()
                        .secondDarkColor(1))),
                textAlign: TextAlign.left),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                item.addressDescription != "ghichu" ? Text(
                    item.addressDescription,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText2
                        .merge(TextStyle(
                        color: item.isSelect ? Colors.white : config.Colors()
                            .secondDarkColor(1))),
                    textAlign: TextAlign.left,
                    maxLines: null) : SizedBox.shrink(),
                Text(item.localName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText2
                        .merge(TextStyle(
                        color: item.isSelect ? Colors.white : config.Colors()
                            .secondDarkColor(1))),
                    textAlign: TextAlign.left,
                    maxLines: null)
              ],
            ),
            trailing: InkWell(
              onTap: () {
                onDeletePressed(item.id);
              },
              child: Material(
                  color: Colors.red,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Icon(Icons.delete, color: Colors.white, size: 18.0),
                  )),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
