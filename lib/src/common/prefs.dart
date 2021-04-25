import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';
import 'package:veca_customer/src/models/user_response.dart';

class Prefs {
  static saveUser(User user) async {
    var jsonString = user.toRawJson();
    (await _sharePref()).setString(_PREF_USER, jsonString);
  }

  static Future<User> getUser() async {
    var jsonString = (await _sharePref()).getString(_PREF_USER);
    if (jsonString != null && jsonString.isNotEmpty) {
      User user = User.fromRawJson(jsonString);
      return user;
    }
    return null;
  }

  static saveAccount(Account user) async {
    var jsonString = user.toRawJson();
    (await _sharePref()).setString(_ACCOUNT, jsonString);
  }

  static Future<Account> getAccount() async {
    var jsonString = (await _sharePref()).getString(_ACCOUNT);
    if (jsonString != null && jsonString.isNotEmpty) {
      Account user = Account.fromRawJson(jsonString);
      return user;
    }
    return null;
  }

  static clearAll() async {
    saveToken('');
  }

  static saveToken(String token) async {
    (await _sharePref()).setString(_PREF_TOKEN, token);
  }

  static getToken() async {
    var token = (await _sharePref()).getString(_PREF_TOKEN);
    if (token == null) {
      token = "";
    }
    return token;
  }

  static saveFCMToken(String token) async {
    (await _sharePref()).setString(_PREF_FCM_TOKEN, token);
  }

  static getFCMToken() async {
    var token = (await _sharePref()).getString(_PREF_FCM_TOKEN);
    if (token == null) {
      token = "";
    }
    return token;
  }

  static saveCurrency(String token) async {
    (await _sharePref()).setString(_CURRENCY, token);
  }

  static getCurrency() async {
    var token = (await _sharePref()).getString(_CURRENCY);
    if (token == null) {
      token = "đ";
    }
    return token;
  }

  static saveHasAccount(bool isSkip) async {
    (await _sharePref()).setBool(_ISHASACCOUNT, isSkip);
  }

  static isHasAccount() async {
    var skip = (await _sharePref()).getBool(_ISHASACCOUNT);
    if (skip == null) {
      skip = false;
    }
    return skip;
  }

  static saveMOMO(bool isSkip) async {
    (await _sharePref()).setBool(_IS_SHOW_MOMO, isSkip);
  }

  static isShowMOMO() async {
    var skip = (await _sharePref()).getBool(_IS_SHOW_MOMO);
    if (skip == null) {
      skip = false;
    }
    return skip;
  }

  static Future<SharedPreferences> _sharePref() async {
    return SharedPreferences.getInstance();
  }

  static needToShowWalkThrough() async {
    return (await _sharePref()).getBool(_PREF_NEED_SHOW_WALK_THROUGH);
  }

  static setNeedToShowWalkThrough(bool isNeedToShow) async {
    (await _sharePref()).setBool(_PREF_NEED_SHOW_WALK_THROUGH, isNeedToShow);
  }

  static logout() async {
    (await _sharePref()).clear();
  }

  static saveBadgeCart(int badge) async {
    (await _sharePref()).setInt(_BADGE_CART, badge);
  }

  static Future<int> getBadgeCart() async {
    var badge = (await _sharePref()).getInt(_BADGE_CART);
    if (badge == null) {
      badge = 0;
    }
    return badge;
  }

  static Future<void> setIsAskedVersion(bool isAsked) async {
    (await _sharePref()).setBool(_PREF_IS_ASKED_VERSION, isAsked);
  }

  static saveLanguages(String languageCode) async {
    (await _sharePref()).setString(_LANGUAGES, languageCode);
  }

  static Future<String> getLanguages() async {
    var languages = (await _sharePref()).getString(_LANGUAGES);
    return languages;
  }

  static const _PREF_USER = "_PREF_USER";
  static const _PREF_TOKEN = "_PREF_TOKEN";
  static const _PREF_FCM_TOKEN = "_PREF_FCM_TOKEN";
  static const _CURRENCY = "_CURRENCY";
  static const _PREF_NEED_SHOW_WALK_THROUGH = "_PREF_NEED_SHOW_WALK_THROUGH";
  static const _IS_SKIP = "_IS_SKIP";
  static const _BADGE_CART = "_BADGE_CART";
  static const APPLE_ID = "APPLE_ID";
  static const APPLE_EMAIL = "APPLE_EMAIL";
  static const APPLE_NAME = "APPLE_NAME";
  static const APPLE_IDENTITY_TOKEN = "APPLE_IDENTITY_TOKEN";
  static const APPLE_AUTHORIZATION_CODE = "APPLE_AUTHORIZATION_CODE";
  static const _LIST_FAVORITES = "LIST_FAVORITE";
  static const CREDIT_CARD = "CREDIT_CARD";
  static const _PREF_IS_ASKED_VERSION = "_PREF_CURRENT_VERSION";
  static const _LANGUAGES = "LANGUAGES";
  static const _ACCOUNT = "ACCOUNT";
  static const _ISHASACCOUNT = "ISHASACCOUNT";
  static const _IS_SHOW_MOMO = "IS_SHOW_MOMO";
}
