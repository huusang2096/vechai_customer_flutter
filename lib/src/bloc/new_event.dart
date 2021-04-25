import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';

class NewEvent extends BaseEvent {
  int select;
  NewEvent(this.select);
}

class BlogDetailEvent extends BaseEvent {
  int id;
  BlogDetailEvent(this.id);
}
