import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/AddressModel.dart';
import 'package:veca_customer/src/models/AddressRequest.dart';
import 'package:veca_customer/src/models/Enum.dart';
import 'package:veca_customer/src/models/SellRequest.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';

class SellBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOtpState();
  int selectAddressId = -1;
  List<AddressModel> _listAddress = [];
  int _time = -1;

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(
    BaseEvent event,
  ) async* {
    if (event is GetAddressEvent) {
      yield* _getListAdddress();
    }

    if (event is DeleteAddress) {
      yield* _deleteAddress(event.id);
    }

    if (event is UnauthenticatedErrorEvent) {
      yield UnauthenticatedState();
    }

    if (event is UploadSellAddress) {
      yield* _uploadAddress(event.addressRequest);
    }

    if (event is CreateSell) {
      if (selectAddressId == -1) {
        yield ErrorState("please_select_address");
      } else if (event.orderHours == null) {
        yield ErrorState("please_select_time");
      } else {
        if (event.orderHours == OrderHours.officeHours) {
          _time = 1;
        } else if (event.orderHours == OrderHours.outsideOfficeHours) {
          _time = 2;
        } else if (event.orderHours == OrderHours.weekend) {
          _time = 3;
        }

        SellRequest sellRequest = new SellRequest();
        sellRequest.addressId = selectAddressId;
        sellRequest.requestTime = _time;
        yield* _createSell(sellRequest);
      }
    }

    /// Select an address
    if (event is SelectAddress) {
      selectAddressId = event.id;
      final List<AddressModel> updatedItems =
          List<AddressModel>.from(_listAddress).map((AddressModel item) {
        return item.id == event.id
            ? item.copyWith(isSelect: true)
            : item.copyWith(isSelect: false);
      }).toList();
      yield AddressList(updatedItems);
    }

    if (event is InternalErrorEvent) {
      yield LoadingState(false);
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _getListAdddress() async* {
    var addressReposne = await Repository.instance.getUserAddress();
    if (addressReposne != null && addressReposne.success) {
      _listAddress = addressReposne.data;
      if(selectAddressId > -1){
        final List<AddressModel> updatedItems =
        List<AddressModel>.from(_listAddress).map((AddressModel item) {
          return item.id == selectAddressId
              ? item.copyWith(isSelect: true)
              : item.copyWith(isSelect: false);
        }).toList();
        yield AddressList(updatedItems);
      } else {
        yield AddressList(addressReposne.data);
      }
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> _deleteAddress(int id) async* {
    if(id == selectAddressId){
      selectAddressId = -1;
    }
    var addressReposne = await Repository.instance.deleteAddress(id);
    if (addressReposne != null && addressReposne.success) {
      add(GetAddressEvent());
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> _uploadAddress(AddressRequest addressRequest) async* {
    final response = await Repository.instance.addAddress(addressRequest);
    if (response != null && response.data != null) {
      selectAddressId = response.data.id;
      add(GetAddressEvent());
    } else {
      yield ErrorState('login_failed');
    }
  }

  Stream<BaseState> _createSell(SellRequest sellRequest) async* {
    var response = await Repository.instance.createSell(sellRequest);
    if (response != null && response.success) {
      add(GetAddressEvent());
      yield CreateSellSuccess(response);
    } else {
      yield ErrorState('Empty');
    }
  }
}
