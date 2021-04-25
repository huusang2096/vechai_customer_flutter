abstract class BaseState {}

class ErrorState extends BaseState {
  final String error;

  ErrorState(this.error);
}

class UnauthenticatedState extends BaseState {}

class LoadingState extends BaseState {
  final bool isLoading;

  LoadingState(this.isLoading);
}
