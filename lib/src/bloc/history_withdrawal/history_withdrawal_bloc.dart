import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/history_withdrawal/history_withdrawal_event.dart';
import 'package:veca_customer/src/bloc/history_withdrawal/history_withdrawal_state.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';

class HistoryWithdrawalBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => HistoryWithdrawalState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is GetListHistoryWithdrawal) {
      yield* _getHistoryWithdrawal();
    }
    if (event is DeletePayout) {
      yield* _deletePayout(event.payoutId);
    }
  }

  Stream<BaseState> _deletePayout(int payoutId) async* {
    try {
      final response = await Repository.instance.deletePayout(payoutId);
      if (response != null && response.success) {
        add(GetListHistoryWithdrawal());
        yield DeletePayoutSuccessState();
      } else {
        yield ErrorState('delete_payout_fail');
      }
    } catch (e) {
      yield ErrorState('server_error');
    }
  }

  Stream<BaseState> _getHistoryWithdrawal() async* {
    try {
      final response = await Repository.instance.getListWithdrawalMomo();
      if (response != null) {
        yield GetListWithdrawalMomoSuccess(response: response);
      } else {
        yield ErrorState('get_list_history_withdrawal_fail');
      }
    } catch (e) {
      yield ErrorState('server_error');
    }
  }
}
