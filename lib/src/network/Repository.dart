import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:veca_customer/src/bloc/bloc.dart';
import 'package:veca_customer/src/common/prefs.dart';
import 'package:veca_customer/src/models/AboutResponse.dart';
import 'package:veca_customer/src/models/AccountRequest.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';
import 'package:veca_customer/src/models/AddAddressResponse.dart';
import 'package:veca_customer/src/models/AddressRequest.dart';
import 'package:veca_customer/src/models/BlogDetailResponse.dart';
import 'package:veca_customer/src/models/BlogResponse.dart';
import 'package:veca_customer/src/models/ChangePassRequest.dart';
import 'package:veca_customer/src/models/CheckPhoneNumberResponse.dart';
import 'package:veca_customer/src/models/LoginTokenRequest.dart';
import 'package:veca_customer/src/models/OrderResponse.dart';
import 'package:veca_customer/src/models/RequestPhoneNumberResponse.dart';
import 'package:veca_customer/src/models/ScrapDetailResponse.dart';
import 'package:veca_customer/src/models/ScrapResponse.dart';
import 'package:veca_customer/src/models/SellRequest.dart';
import 'package:veca_customer/src/models/SellResponse.dart';
import 'package:veca_customer/src/models/SendOTPResponse.dart';
import 'package:veca_customer/src/models/UploadImageResponse.dart';
import 'package:veca_customer/src/models/UploadUser.dart';
import 'package:veca_customer/src/models/UserAddressResponse.dart';
import 'package:veca_customer/src/models/VerifyOTPResponse.dart';
import 'package:veca_customer/src/models/VerifyOtpRequest.dart';
import 'package:veca_customer/src/models/basemodel.dart';
import 'package:veca_customer/src/models/login_account_request.dart';
import 'package:veca_customer/src/models/momo_denominations_response.dart';
import 'package:veca_customer/src/models/momo_history_withdrawal_response.dart';
import 'package:veca_customer/src/models/momo_response.dart';
import 'package:veca_customer/src/models/notification.dart';
import 'package:veca_customer/src/models/token_request.dart';
import 'package:veca_customer/src/network/RestClient.dart';
import 'package:veca_customer/src/uitls/device_helper.dart';

class Repository {
  final logger = Logger();
  final dio = Dio();
  RestClient _client;

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Repository._privateConstructor() {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    _client = RestClient(dio);
    reloadHeaders();
  }

  static final Repository instance = Repository._privateConstructor();

  Future<void> reloadHeaders() async {
    final languageCode = await Prefs.getLanguages();
    dio.options.headers["Accept-Language"] = languageCode;
    //dio.options.headers["Content-Type"] = "application/json";
    final token = await Prefs.getToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    print("TOKEN " + token);
  }

  Future<CheckPhoneNumberResponse> checkPhoneNumber(
      RequestPhoneNumberResponse phoneNumberRequest) {
    return _client.checkPhonenumber(phoneNumberRequest);
  }

  Future<SendOTPResponse> requestOTP(
      RequestPhoneNumberResponse phoneNumberRequest) {
    return _client.requestOTP(phoneNumberRequest);
  }

  Future<VerifyOtpResponse> verifyOTP(VerifyOtpRequest verifyOtpRequest) {
    return _client.verifyOTP(verifyOtpRequest);
  }

  Future<AccountResponse> createAccpunt(AccountRequest accountRequest) {
    return _client.createAccount(accountRequest);
  }

  Future<AccountResponse> loginAccount(LoginAccountRequest accountRequest) {
    return _client.loginAccount(accountRequest);
  }

  Future<AccountResponse> loginwithOTP(LoginTokenRequest loginTokenRequest) {
    return _client.loginWithOTP(loginTokenRequest);
  }

  Future<UploadImageResponse> updateImageProfile(File file) {
    return _client.updateImageProfile(file);
  }

  Future<UploadImageResponse> updateImageProfileUrl(String avartarUrl) {
    return _client.updateImageProfileUrl(avartarUrl);
  }

  Future<AccountResponse> updateProfile(UploadUser UploadUser) {
    return _client.updateProfile(UploadUser);
  }

  Future<AccountResponse> getUserProfile() {
    return _client.getUserProfile();
  }

  Future<ScrapResponse> getListScrap() {
    return _client.getListScrap();
  }

  Future<ScrapDetailResponse> getScrapDetail(int id) {
    return _client.getScrapDetail(id);
  }

  Future<UserAddressResponse> getUserAddress() {
    return _client.getUserAddress();
  }

  Future<AddAddressResponse> addAddress(AddressRequest addressRequest) {
    return _client.getAddressRequests(addressRequest);
  }

  Future<SellResponse> createSell(SellRequest sellRequest) {
    return _client.createSell(sellRequest);
  }

  Future<OrderResponse> getOrderByType(String type) {
    return _client.getListOrder(type);
  }

  Future<BaseModel> removeAcceptRequest(int id) {
    return _client.removeRequest(id);
  }

  Future<BlogResponse> getBlogByCategory(int id) {
    return _client.getBlogByCategory(id);
  }

  Future<BlogDetailResponse> getBlogDetail(int id) {
    return _client.getBlogDetailByCategory(id);
  }

  Future<BaseModel> sendFCM(TokenRequest tokenRequest) {
    return _client.sendFCM(tokenRequest);
  }

  Future<NotificationResponse> getNotifications() async {
    return _client.getNotification();
  }

  Future<BaseModel> changePass(ChangePassRequest changePassRequest) {
    return _client.changePass(changePassRequest);
  }

  Future<BaseModel> deleteAddress(int id) {
    return _client.deleteAddress(id);
  }

  Future<BaseModel> removeAllNotification() {
    return _client.removeAllNotification();
  }

  Future<BaseModel> removeNotificationItem({int notificationID}) {
    return _client.removenotification(notificationID);
  }

  Future<AboutResponse> getAbout() {
    return _client.getAboutVeca();
  }

  Future<MomoDenominationsResponse> getListDenominations() {
    return _client.getListDenominations();
  }

  Future<MomoResponse> createWithdrawalMomo({int amount, String phone}) {
    return _client.createWithdrawalMomo(amount, phone);
  }

  Future<MomoHistoryWithdrawalResponse> getListWithdrawalMomo() {
    return _client.getListWithdrawalMomo();
  }

  Future<BaseModel> deletePayout(int payoutId) {
    return _client.deletePayout(payoutId);
  }
}
