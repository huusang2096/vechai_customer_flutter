import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/models/AddressResponse.dart';
import './bloc.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  @override
  CreateOrderState get initialState => InitialCreateOrderState();

  final Repository repository;
  int _selectAddressId = -1;
  int _selectPaymentMethod = -1;
  List<Address> _listAddress = [];

  CreateOrderBloc({this.repository});

  @override
  Stream<CreateOrderState> mapEventToState(
    CreateOrderEvent event,
  ) async* {
    // TODO: Add Logic

    /// Select an address
    if (event is SelectAddress) {
      _selectAddressId = event.id;
      final List<Address> updatedItems =
      List<Address>.from(_listAddress).map((Address item) {
        return item.id == event.id
            ? item.copyWith(isSelect: true)
            : item.copyWith(isSelect: false);
      }).toList();
      yield LoadedAddress(items: updatedItems);
    }

  }
}
