import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/notification.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';

class NotificationsBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOrdersState();

  List<NotificationData> userNotification;
  List<NotificationData> sytemNotification;

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {
    if (event is NotificationEvent) {
      yield* getNotification();
    }

    if (event is RemoveAllNotification) {
      yield* removeAllNotification();
    }

    if (event is RemoveNotificationItemEvent) {
      yield* removeNotificationItem(event.notificationID);
    }


    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  // TODO: Handle show message
  Stream<BaseState> removeAllNotification() async* {
    yield LoadingState(true);
    try {
      final response = await Repository.instance.removeAllNotification();
      if (response != null) {
        yield LoadingState(false);
        add(NotificationEvent());
      } else {
        yield LoadingState(false);
      }
    } catch (e) {
      yield LoadingState(false);
    }
  }

  // TODO: Handle show message;
  Stream<BaseState> removeNotificationItem(int id) async* {
    try {
      yield LoadingState(true);
      final response = await Repository.instance.removeNotificationItem(notificationID: id);
      if (response != null) {
        add(NotificationEvent());
      } else {
        yield LoadingState(false);
      }
    } catch (e) {
      yield LoadingState(false);
    }
  }

  Stream<BaseState> getNotification() async* {
    var response = await Repository.instance.getNotifications();
    if (response != null && response.success) {
      sytemNotification = response.data.systemNotifications;
      userNotification = response.data.userNotifications;
      yield NotificationsSuccessState();
    } else {
      yield ErrorState('Empty');
    }
  }
}