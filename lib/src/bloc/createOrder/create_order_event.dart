import 'package:meta/meta.dart';

@immutable
abstract class CreateOrderEvent {
  const CreateOrderEvent();
}

class SelectAddress extends CreateOrderEvent {
  final int id;
  SelectAddress({@required this.id});
}