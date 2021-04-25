import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';

class HomeBlocBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialHomeBlocState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if (event is HomeScrap) {
      yield* _getListScrap();
    }

    if(event is HomeScrapDetail){
      yield* _getScrapDetail(event.id);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _getScrapDetail(int id) async* {
    yield LoadingState(true);
    final response = await Repository.instance.getScrapDetail(id);
    if (response != null && response.data != null) {
      yield LoadingState(false);
      yield GetScrapDetailSuccessState(response);
    } else {
      yield LoadingState(false);
      yield ErrorState('Empty');
    }
  }

  Stream<BaseState> _getListScrap() async* {
    yield LoadingState(true);
    final response = await Repository.instance.getListScrap();
    if (response != null && response.data != null) {
      yield LoadingState(false);
      yield GetListScrapSuccessState(response.data);
    } else {
      yield LoadingState(false);
      yield ErrorState('Empty');
    }
  }
}
