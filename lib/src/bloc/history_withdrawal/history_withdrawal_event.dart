import 'package:veca_customer/src/bloc/base_event.dart';

class HistoryWithdrawal extends BaseEvent {}

class GetListHistoryWithdrawal extends BaseEvent {}

class DeletePayout extends BaseEvent {
  int payoutId;
  DeletePayout(this.payoutId);
}
