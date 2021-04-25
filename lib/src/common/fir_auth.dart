import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PhoneAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';
  String _verificationId;

  final Function onVerificationCompleted;
  final Function onVerificationFailed;
  final Function onCodeSent;

  Function onSignSuccess;
  final Function onSignFailed;

  int _forceResendingToken;

  PhoneAuth(
      {@required this.onVerificationCompleted,
        @required this.onVerificationFailed,
        @required this.onCodeSent,
        this.onSignSuccess,
        @required this.onSignFailed})
      : assert(onVerificationCompleted != null &&
      onVerificationFailed != null &&
      onCodeSent != null &&
      // onSignSuccess != null &&
      onSignFailed != null) {
    _auth.signOut();
    _auth.onAuthStateChanged.listen((user) {
      Logger().i('onAuthStateChanged $user');
      if (user != null && onSignSuccess != null) {
        onSignSuccess(user);
      }
    });
  }

  verifyPhoneNumber(String phoneNumber) async {
    _message = '';
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      _message = 'Received phone auth credential: $phoneAuthCredential';
      Logger().i(_message);
      onVerificationCompleted(phoneAuthCredential);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _message =
      'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      Logger().i(_message);
      onVerificationFailed(authException);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _message = 'Please check your phone for the verification code.';
      Logger().i(_message);
      _forceResendingToken = forceResendingToken;
      _verificationId = verificationId;
      onCodeSent(verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        forceResendingToken: _forceResendingToken,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  Future<FirebaseUser> signInWithPhoneNumber(String smsCode,
      {String verificationId}) async {
    if (verificationId != null) {
      _verificationId = verificationId;
    }
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    try {
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      if (user != null) {
        _message = 'Successfully signed in, uid: ' + user.uid;
        Logger().i(_message);
        if (onSignSuccess != null) {
          onSignSuccess(user);
        }
      } else {
        onSignFailed();
        _message = 'Sign in failed';
        Logger().i(_message);
      }
      return user;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }
}
