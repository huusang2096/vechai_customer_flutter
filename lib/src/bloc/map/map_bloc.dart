import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:veca_customer/config/config.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/bloc/map/map_event.dart';
import 'package:veca_customer/src/bloc/map/map_state.dart';
import 'package:veca_customer/src/models/SearchPlaceResponse.dart';
import 'package:veca_customer/src/models/place_model.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  List<Place> listPlace;
  Repository repository;
  final dio = Dio();

  MapBloc({this.repository});

  @override
  MapState get initialState => InitialMapState();

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    try {
      if (event is SearchPlaceEvent) {
        final list = await search(event.query);
        listPlace = list;
        yield UpdateListPlaceState(listPlace);
      }
    } catch (err) {
      print(err);
      yield LoadingState(false);
      yield ErrorMapState(err);
    }
  }

  Future<List<Place>> search(String query) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=${Config.apiKey}&language=${Config.language}&region=${Config.region}&query=" +
            Uri.encodeQueryComponent(query); //Uri.encodeQueryComponent(query)
    print(url);
    Response response = await Dio().get(url);
    print(Place.parseLocationList(response.data));
    listPlace = Place.parseLocationList(response.data);
    return listPlace;
  }
}

