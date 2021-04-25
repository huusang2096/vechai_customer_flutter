import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/AddressModel.dart';
import 'package:veca_customer/src/models/SellResponse.dart';

class InitialSellState extends BaseState {}

class CreateSellSuccess extends BaseState{
  SellResponse sellResponse;

  CreateSellSuccess(this.sellResponse);
}

class AddressList extends BaseState{
  List<AddressModel> data;

  AddressList(this.data);
}