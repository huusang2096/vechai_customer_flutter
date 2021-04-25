import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';

class OrdersBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOrdersState();
  List<OrderModel> ordersPendding = [];
  List<OrderModel> ordersConfrim = [];
  List<OrderModel> ordersFinish = [];
  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {

    if(event is OrderEvent){
      yield* getOrderByeType(event.type);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }

    if(event is RemoveOrderEvent){
      yield* removeOrderType(event.id);
    }

  }

  Stream<BaseState> removeOrderType(int id) async* {
    var response = await Repository.instance.removeAcceptRequest(id);
    if (response != null && response.success) {
      yield DeleteOrderSuccessState(response.message);
    } else {
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> getOrderByeType(String type) async* {
    var response = await Repository.instance.getOrderByType(type);
    if (response != null && response.success) {
      if(type == "pending"){
        ordersPendding = response.data;
      } else if(type == "accepted"){
        ordersConfrim = response.data;
      } else if(type == "finished"){
        ordersFinish = response.data;
      }
      yield OrderSuccessState(response.data);
    } else {
      yield ErrorState('Empty');
    }
  }
}