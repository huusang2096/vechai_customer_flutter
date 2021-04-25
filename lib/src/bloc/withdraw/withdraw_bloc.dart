import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_number/phone_number.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/withdraw/withdraw_event.dart';
import 'package:veca_customer/src/bloc/withdraw/withdraw_state.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import 'package:veca_customer/src/uitls/phone_helper.dart';

class WithdrawBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => WithdrawState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is CheckShowInstalMoMoEvent) {
      yield* checkShowMOMO();
    }
    if (event is Withdraw) {
      yield* _withdraw(event.price, event.phone);
    }
    if (event is GetDenominations) {
      yield* _getDenominations();
    }
    if (event is SelectDenomination) {
      if (event.id == -1) {
        yield ChangeSuffixIconState(true);
      } else {
        yield ChangeSuffixIconState(false);
      }
      yield SelectDenominationState(event.id);
    }
    if (event is TextChange) {
      if (event.value.trim().isEmpty) {
        yield ChangeSuffixIconState(true);
      } else {
        yield ChangeSuffixIconState(false);
      }
    }
  }

  Stream<BaseState> checkShowMOMO() async* {
    bool isShow = await Prefs.isShowMOMO();
    Prefs.saveMOMO(true);
    yield ISShowMOMOState(isShow);
  }

  Stream<BaseState> _getDenominations() async* {
    final response = await Repository.instance.getListDenominations();
    if (response != null) {
      yield GetListDenominationSuccess(response);
    } else {
      yield ErrorState('get_list_denomination_fail');
    }
  }

  Stream<BaseState> _withdraw(int price, String phonenumber) async* {
    yield LoadingState(true);
    final phoneModel = await PhoneHelper.parseFullPhone(phonenumber);
    if (phoneModel == null) {
      yield ErrorState('phone_number_error');
      return;
    }
    String fullPhone = phoneModel.national.toString().replaceAll(" ", "");
    final response = await Repository.instance
        .createWithdrawalMomo(amount: price, phone: fullPhone);
    if (response != null) {
      yield LoadingState(false);
      yield ChangeSuffixIconState(true);
      yield SelectDenominationState(-1);
      yield WithdrawSuccessState(response.message, response.data.user.balance);
    } else {
      yield LoadingState(false);
      yield ChangeSuffixIconState(true);
      yield SelectDenominationState(-1);
      yield ErrorState('withdraw_failed');
    }
  }
}
