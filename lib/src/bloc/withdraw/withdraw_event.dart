import 'package:veca_customer/src/bloc/base_event.dart';

class Withdraw extends BaseEvent {
  int price;
  String phone;
  Withdraw(this.price, this.phone);
}

class GetDenominations extends BaseEvent {}

class CheckShowInstalMoMoEvent extends BaseEvent {}

class SelectDenomination extends BaseEvent {
  int id;
  SelectDenomination(this.id);
}

class TextChange extends BaseEvent {
  String value;
  TextChange(this.value);
}
