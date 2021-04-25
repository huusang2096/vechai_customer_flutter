import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';

class InitialOrdersState extends BaseState {}

class OrderSuccessState extends BaseState {
  List<OrderModel> orders;

  OrderSuccessState(this.orders);
}

class DeleteOrderSuccessState extends BaseState {
  String message;
  DeleteOrderSuccessState(this.message);

}