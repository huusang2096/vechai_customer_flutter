import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> {
  @override
  TabsState get initialState => InitialTabsState();

  @override
  Stream<TabsState> mapEventToState(
    TabsEvent event,
  ) async* {
  }
}
