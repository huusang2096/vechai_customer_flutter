import 'package:equatable/equatable.dart';

abstract class TabsState extends Equatable {
  const TabsState();
}

class InitialTabsState extends TabsState {
  @override
  List<Object> get props => [];
}
