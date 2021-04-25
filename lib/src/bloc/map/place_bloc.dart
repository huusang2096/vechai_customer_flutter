import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/config/config.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/models/place_model.dart';


class PlaceBloc with ChangeNotifier {
  StreamController<Place> locationController =
      StreamController<Place>.broadcast();
  Place locationSelect;
  Place formLocation;
  List<Place> listPlace;
  Repository repository = Repository.instance;
  List<Place> listPlaceSearch;

  PlaceBloc({this.repository});

  Stream get placeStream => locationController.stream;

  void locationSelected(Place location) {
    locationController.sink.add(location);
  }

  Future<void> selectLocation(Place location) async {
    notifyListeners();
    locationSelect = location;
    return locationSelect;
  }

  Future<void> getCurrentLocation(Place location) async {
    notifyListeners();
    formLocation = location;
    return formLocation;
  }


  @override
  void dispose() {
    locationController.close();
    super.dispose();
  }
}
