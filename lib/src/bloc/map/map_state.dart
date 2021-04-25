import 'package:veca_customer/src/models/place_model.dart';

abstract class MapState {}

class InitialMapState extends MapState {}

class LoadingState extends MapState {
  bool isShow;

  LoadingState(this.isShow);
}

class ErrorMapState extends MapState {
  String error;
  ErrorMapState(this.error);
}

class DrawRouteAndMarkers extends MapState {}

class UpdateListPlaceState extends MapState {
  List<Place> listPlace;

  UpdateListPlaceState(this.listPlace);
}

