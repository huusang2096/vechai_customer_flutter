import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/models/AddressResponse.dart';
import 'package:veca_customer/src/network/Repository.dart';
import './bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  @override
  AddressState get initialState => InitialAddressState();

  final Repository repository;

  AddressBloc({this.repository});

  @override
  Stream<AddressState> mapEventToState(AddressEvent event,) async* {
    if (event is FetchAddressList) {
      try {
        var addressReposne = await repository.getUserAddress();
        if (addressReposne.success) {
          yield LoadedAddress(items: addressReposne.data);
        } else {
          yield LoadAddressFailure(error: addressReposne.message);
        }
      } catch (error) {
        yield LoadAddressFailure(error: error.toString());
      }
    }

    if(event is DeleteAddress){
      try {
        var addressReposne = await repository.deleteAddress(event.id);
        if (addressReposne.success) {
          add(FetchAddressList());
        } else {
          yield LoadAddressFailure(error: addressReposne.message);
        }
      } catch (error) {
        yield LoadAddressFailure(error: error.toString());
      }
    }
  }
}
