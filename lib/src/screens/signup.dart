import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/bloc/base_state.dart';
import 'package:veca_customer/src/bloc/update_profile_bloc.dart';
import 'package:veca_customer/src/bloc/update_profile_event.dart';
import 'package:veca_customer/src/bloc/update_profile_state.dart';
import 'package:veca_customer/src/common/const.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/AddressModel.dart';
import 'package:veca_customer/src/models/UploadUser.dart';
import 'package:veca_customer/src/models/facebook_profile.dart';
import 'package:http/http.dart' as http;
import 'package:veca_customer/src/widgets/rouned_flat_button.dart';

class SignUpWidget extends StatefulWidget {
  static provider(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateProfileBloc(),
      child: SignUpWidget(),
    );
  }

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> with UIHelper {
  var _nameText = "";
  var _emailText = "";
  var txt = TextEditingController();
  var _name = TextEditingController();
  var _email = TextEditingController();

  UpdateProfileBloc bloc;
  File imagefile;
  String imageUrl;
  String lastSelectedValue;
  var fbToken = '';
  FacebookProfile fbProfile = null;
  GlobalKey<FormState> _profileFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    bloc = BlocProvider.of<UpdateProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  _loginFacebook() async {
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        return result.accessToken.token;
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
    throw "";
  }

  Future<FacebookProfile> _fetchFacebookProfile(String token) async {
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
    print(graphResponse.body);
    print("---------$token");
    print("----------Response " + graphResponse.body);
    var fbProfile = FacebookProfile.fromRawJson(graphResponse.body);
    return fbProfile;
  }

  _onTapFacebook() async {
    try {
      this.fbToken = await _loginFacebook();
      fbProfile = await _fetchFacebookProfile(fbToken);
      if (fbProfile.email != null) {
        setState(() {
          /* var url = "https://graph.facebook.com/" +
              fbProfile.id +
              "/picture?type=large";*/
          bloc.add(UploadImageUrl(fbProfile.picture.data.url));
          print('Url: ${fbProfile.picture.data.url}');
          _nameText = fbProfile.firstName + fbProfile.lastName;
          _emailText = fbProfile.email;
          _name.text = fbProfile.firstName + fbProfile.lastName;
          _email.text = fbProfile.email;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Future getImageLibrary() async {
    var gallery =
        await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700);
    setState(() {
      imagefile = gallery;
      bloc.add(UploadImage(imagefile));
    });
  }

  Future cameraImage() async {
    var image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 700);
    setState(() {
      imagefile = image;
      bloc.add(UploadImage(imagefile));
    });
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  selectCamera() {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
          title: Text(localizedText(context, 'select_camera')),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(localizedText(context, 'camera')),
              onPressed: () {
                Navigator.pop(context, 'Camera');
                cameraImage();
              },
            ),
            CupertinoActionSheetAction(
              child: Text(localizedText(context, 'photo_library')),
              onPressed: () {
                Navigator.pop(context, 'Photo Library');
                getImageLibrary();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localizedText(context, 'cancel_normal')),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
  }

  Widget build(BuildContext context) {
    _onSignUpPressed() {
      if (_profileFormKey.currentState.validate()) {
        _profileFormKey.currentState.save();
        UploadUser uploadUser = new UploadUser();
        uploadUser.email = _emailText;
        uploadUser.name = _nameText;
        bloc.add(UploadProfile(uploadUser));
      }
    }

    _userAvatar() {
      if (imageUrl != null) {
        return CachedNetworkImageProvider(imageUrl);
      } else {
        return AssetImage('img/user_placeholder.png');
      }
    }

    var data = EasyLocalizationProvider.of(context).data;
    return BlocListener<UpdateProfileBloc, BaseState>(listener:
        (context, state) {
      handleCommonState(context, state);
      if (state is UploadImageSuccessState) {
        imageUrl = state.uploadImageResponse.data.path;
      }

      if (state is UploadProfileSuccessState) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/Tabs", (Route<dynamic> route) => false,
            arguments: 0);
      }
    }, child:
        BlocBuilder<UpdateProfileBloc, BaseState>(builder: (context, state) {
      return EasyLocalizationProvider(
        data: data,
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Stack(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        gradient: getLinearGradient())),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height / 5, 20, 10),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.15),
                          offset: Offset(0, 3),
                          blurRadius: 10)
                    ],
                  ),
                  child: SingleChildScrollView(
                      child: Form(
                    key: _profileFormKey,
                    child: Column(
                      children: <Widget>[
                        Text(localizedText(context, 'update'),
                            style: Theme.of(context).textTheme.headline3),
                        SizedBox(height: 10),
                        SizedBox(
                            width: 60,
                            height: 60,
                            child: InkWell(
                              onTap: () {
                                selectCamera();
                              },
                              borderRadius: BorderRadius.circular(300),
                              child:
                                  CircleAvatar(backgroundImage: _userAvatar()),
                            )),
                        SizedBox(height: 20),
                        RounedFlatButton(
                          borderRadius: 10,
                          height: 54,
                          color: Color(0xff1A73E8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('img/facebook2.png'),
                              SizedBox(width: 8),
                              Text(
                                localizedText(context, 'connect_with_facebook'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPress: () {
                            _onTapFacebook();
                          },
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.text,
                          validator: (input) => input.trim().length < 3
                              ? localizedText(context, 'not_a_valid_full_name')
                              : null,
                          controller: _name,
                          onSaved: (input) => _nameText = input,
                          decoration: new InputDecoration(
                            hintText: localizedText(context, 'name'),
                            hintStyle:
                                Theme.of(context).textTheme.subtitle2.merge(
                                      TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 30.0, right: 30),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset('img/profile.png'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          validator: (input) => !input.contains('@')
                              ? localizedText(context, 'not_a_valid_email')
                              : null,
                          onSaved: (input) => _emailText = input,
                          decoration: new InputDecoration(
                            hintText: localizedText(context, "email_addr"),
                            hintStyle:
                                Theme.of(context).textTheme.subtitle2.merge(
                                      TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor),
                            ),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Image.asset('img/email.png'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: _onSignUpPressed,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: getLinearGradient(),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    localizedText(context, 'new_update'),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .merge(TextStyle(color: Colors.white))),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
                Positioned(
                    top: 40,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/Tabs", (Route<dynamic> route) => false,
                            arguments: 0);
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.0),
                          ),
                        ),
                        child: Icon(
                          Icons.clear,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    )),
              ],
            )),
      );
    }));
  }
}
