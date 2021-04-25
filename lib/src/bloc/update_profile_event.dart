import 'dart:io';

import 'package:meta/meta.dart';
import 'package:veca_customer/src/models/UploadUser.dart';

import 'base_event.dart';

class UploadProfile extends BaseEvent {
  UploadUser uploadUser;

  UploadProfile(this.uploadUser);
}

class UploadImage extends BaseEvent {
  File image;

  UploadImage(this.image);
}

class UploadImageUrl extends BaseEvent {
  String image;

  UploadImageUrl(this.image);
}