import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/models/UploadUser.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';

class UpdateProfileBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialOtpState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(
    BaseEvent event,
  ) async* {

    if(event is UploadImage){
      yield* _uploadImage(event.image);
    }

    if(event is UploadImageUrl){
      yield* _uploadImageUrl(event.image);
    }

    if(event is UploadProfile){
      yield* _uploadProfile(event.uploadUser);
    }


    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }
  }

  Stream<BaseState> _uploadImage(File image) async* {
    yield LoadingState(true);
    final response = await Repository.instance.updateImageProfile(image);
    if (response != null) {
      yield LoadingState(false);
      yield UploadImageSuccessState(response);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }

  Stream<BaseState> _uploadImageUrl(String image) async* {
    yield LoadingState(true);
    final response = await Repository.instance.updateImageProfileUrl(image);
    if (response != null) {
      yield LoadingState(false);
      yield UploadImageSuccessState(response);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }


  Stream<BaseState> _uploadProfile(UploadUser uploadUser) async* {
    yield LoadingState(true);
    final response = await Repository.instance.updateProfile(uploadUser);
    if (response != null) {
      yield LoadingState(false);
      if(response.data.apiToken.isNotEmpty){
        await Prefs.saveToken(response.data.apiToken);
      }
      await Prefs.saveAccount(response.data);
      Repository.instance.reloadHeaders();
      yield UploadProfileSuccessState(response);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }
}
