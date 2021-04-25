abstract class MapEvent {}

class SearchPlaceEvent extends MapEvent {
  String query;
  SearchPlaceEvent(this.query);
}

