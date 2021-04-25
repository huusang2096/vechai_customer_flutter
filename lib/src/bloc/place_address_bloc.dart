import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/AddressRequest.dart';
import 'package:veca_customer/src/models/place_model.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';

class PlaceAddressBloc extends Bloc<BaseEvent, BaseState> with BlocHelper, ChangeNotifier {
  @override
  BaseState get initialState => InitialPlaceAddressState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {

    if(event is UploadAddress){
      yield* _uploadAddress(event.addressRequest);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _uploadAddress(AddressRequest addressRequest) async* {
    final response = await Repository.instance.addAddress(addressRequest);
    if (response != null && response.data != null) {
      yield UploadAddressSuccessState(response.message, response.data);
    } else {
      yield ErrorState('login_failed');
    }
  }
}
