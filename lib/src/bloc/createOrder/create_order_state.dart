import 'package:meta/meta.dart';
import 'package:veca_customer/src/models/AddressResponse.dart';

@immutable
abstract class CreateOrderState {
  const CreateOrderState();
}

class InitialCreateOrderState extends CreateOrderState {}


class LoadedAddress extends CreateOrderState {
  final List<Address> items;

  const LoadedAddress({@required this.items});
  @override
  String toString() => 'Loaded { items: ${items.length} }';
}