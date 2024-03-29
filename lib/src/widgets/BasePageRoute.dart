
import 'package:flutter/material.dart';

class BasePageRoute<T> extends MaterialPageRoute<T> {
  BasePageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
      builder: builder,
      maintainState: maintainState,
      settings: settings,
      fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {

    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}