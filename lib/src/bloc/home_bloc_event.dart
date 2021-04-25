import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
class HomeScrap extends BaseEvent {
  HomeScrap();
}

class HomeScrapDetail extends BaseEvent {
  int id;
  HomeScrapDetail(this.id);
}