import 'dart:io';

import 'package:meta/meta.dart';
import 'package:veca_customer/src/bloc/base_event.dart';
import 'package:veca_customer/src/models/UploadUser.dart';

class GetAccountData extends BaseEvent {
  GetAccountData();
}

class UploadProfileImage extends BaseEvent {
  File image;

  UploadProfileImage(this.image);
}

class UploadProfileImageUrl extends BaseEvent {
  String image;

  UploadProfileImageUrl(this.image);
}

class UpdateProfile extends BaseEvent {
  UploadUser uploadUser;

  UpdateProfile(this.uploadUser);
}