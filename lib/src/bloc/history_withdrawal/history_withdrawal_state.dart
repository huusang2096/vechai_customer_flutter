import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/momo_history_withdrawal_response.dart';

class HistoryWithdrawalState extends BaseState {}

class GetListWithdrawalMomoSuccess extends BaseState {
  MomoHistoryWithdrawalResponse response;
  GetListWithdrawalMomoSuccess({this.response});
}

class DeletePayoutSuccessState extends BaseState {}
