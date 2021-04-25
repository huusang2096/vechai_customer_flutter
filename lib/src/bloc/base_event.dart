abstract class BaseEvent {}

class InternalErrorEvent extends BaseEvent {
  final String error;

  InternalErrorEvent(this.error);
}

class UnauthenticatedErrorEvent extends BaseEvent {}

