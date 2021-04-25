import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/models/error_response.dart';


class BlocHelper {
  blocHandleError(Bloc bloc, dynamic error) {
    if (error is String) {
      bloc.add(InternalErrorEvent(error));
    }

    if (error is DioError) {
      var response = error.response?.data ?? {"message": "server_error"};
      if(error.response.statusCode == 401){
        bloc.add(UnauthenticatedErrorEvent());
      } else {
        if(response is Map){
          var errResponse = ErrorResponse.fromJson(response);
          bloc.add(InternalErrorEvent(errResponse.message));
        } else if(response is String){
          var errResponse = ErrorResponse.fromRawJson(response);
          bloc.add(InternalErrorEvent(errResponse.message));
        } else {
          bloc.add(InternalErrorEvent("server_error"));
        }
      }
    }
  }

  Stream<BaseState> blocHandleMapEvent(BaseEvent event) async* {
//    yield
  }
}
