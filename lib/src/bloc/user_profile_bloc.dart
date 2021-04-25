import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';
import 'package:veca_customer/src/models/UploadUser.dart';
import 'package:veca_customer/src/network/Repository.dart';
import 'package:veca_customer/src/uitls/bloc_helper.dart';
import './bloc.dart';
import 'base_event.dart';

class UserProfileBloc extends Bloc<BaseEvent, BaseState> with BlocHelper {
  @override
  BaseState get initialState => InitialUserProfileState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    blocHandleError(this, error);
  }

  @override
  Stream<BaseState> mapEventToState(BaseEvent event,) async* {

    if(event is GetAccountData){
      yield* _getUserProfile();
    }

    if(event is UpdateProfile){
      yield* _uploadProfile(event.uploadUser);
    }

    if(event is UploadProfileImage){
      yield* _uploadImage(event.image);
    }

    if(event is UploadProfileImageUrl){
      yield* _uploadImageUrl(event.image);
    }

    if (event is InternalErrorEvent) {
      yield ErrorState(event.error);
    }

    if (event is UnauthenticatedErrorEvent) {
      yield UnauthenticatedState();
    }
  }

  Stream<BaseState> _uploadImage(File image) async* {
    yield LoadingState(true);
    final response = await Repository.instance.updateImageProfile(image);
    if (response != null) {
      Account user = await Prefs.getAccount();
      user.avatar = response.data.path;
      Prefs.saveAccount(user);
      yield LoadingState(false);
      yield UploadProfileImageSuccessState(response);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }

  Stream<BaseState> _getUserProfile() async* {
    yield LoadingState(true);
    final response = await Repository.instance.getUserProfile();
    if (response != null) {
      if(response.data.apiToken.isNotEmpty){
        await Prefs.saveToken(response.data.apiToken);
      }
      await Prefs.saveAccount(response.data);
      yield LoadingState(false);
      yield GetUserProfile(response.data);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }

  Stream<BaseState> _uploadImageUrl(String image) async* {
    yield LoadingState(true);
    final response = await Repository.instance.updateImageProfileUrl(image);
    if (response != null) {
      Account user = await Prefs.getAccount();
      user.avatar = response.data.path;
      Prefs.saveAccount(user);
      yield LoadingState(false);
      yield UploadProfileImageSuccessState(response);
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
      yield UpdateProfileSuccessState(response);
    } else {
      yield LoadingState(false);
      yield ErrorState('login_failed');
    }
  }
}

