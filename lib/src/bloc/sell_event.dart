import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/models/AddressRequest.dart';
import 'package:veca_customer/src/models/Enum.dart';
import 'package:veca_customer/src/models/SellRequest.dart';

class GetAddressEvent extends BaseEvent{}

class CreateSell extends BaseEvent{
  OrderHours orderHours;

  CreateSell(this.orderHours);
}

class SelectAddress extends BaseEvent {
  final int id;
  SelectAddress({@required this.id});
}

class DeleteAddress extends BaseEvent {
  final int id;
  DeleteAddress({@required this.id});
}

class UploadSellAddress extends BaseEvent {
  AddressRequest addressRequest;

  UploadSellAddress(this.addressRequest);
}
