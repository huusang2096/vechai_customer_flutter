import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';

class NewBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOrdersState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {

    if (event is NewEvent) {
      yield* getBlogByCategory(event.select);
    }

    if (event is BlogDetailEvent){
      yield* getBlogDetailByCategory(event.id);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }
}

Stream<BaseState> getBlogByCategory(int type) async* {
  var response = await Repository.instance.getBlogByCategory(type);
  if (response != null && response.success) {
    yield ListNewSuccessState(response.data);
  } else {
    yield ErrorState('Empty');
  }
}

Stream<BaseState> getBlogDetailByCategory(int id) async* {
  var response = await Repository.instance.getBlogDetail(id);
  if (response != null && response.success) {
    yield BlogDetailSuccessState(response);
  } else {
    yield ErrorState('Empty');
  }
}
