import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
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

part 'RestClient.g.dart';

@RestApi(baseUrl: "https://veca.di4l.vn/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("api/auth/check-phone-number")
  Future<CheckPhoneNumberResponse> checkPhonenumber(
      @Body() RequestPhoneNumberResponse requestPhoneNumberResponse);

  @POST("api/auth/request-otp")
  Future<SendOTPResponse> requestOTP(
      @Body() RequestPhoneNumberResponse requestPhoneNumberResponse);

  @POST("api/auth/verify-otp")
  Future<VerifyOtpResponse> verifyOTP(
      @Body() VerifyOtpRequest verifyOtpRequest);

  @POST("api/auth/create-password")
  Future<AccountResponse> createAccount(@Body() AccountRequest accountRequest);

  @POST("api/auth/login")
  Future<AccountResponse> loginAccount(
      @Body() LoginAccountRequest loginAccountRequest);

  @POST("api/auth/login-otp")
  Future<AccountResponse> loginWithOTP(
      @Body() LoginTokenRequest loginTokenRequest);

  @POST("api/account/upload-image")
  Future<UploadImageResponse> updateImageProfile(@Part('avatar') File image);

  @POST("api/account/upload-image")
  Future<UploadImageResponse> updateImageProfileUrl(
      @Part('avatar_url') String avatarUrl);

  @PUT("api/account/update-information")
  Future<AccountResponse> updateProfile(@Body() UploadUser UploadUser);

  @GET("api/account/get-account-information")
  Future<AccountResponse> getUserProfile();

  @GET("api/scrap/get-list-scrap-type")
  Future<ScrapResponse> getListScrap();

  @GET("api/scrap/get-scrap-details/{scrap_id}")
  Future<ScrapDetailResponse> getScrapDetail(@Path("scrap_id") int scrap_id);

  @GET("api/address/get-addresses")
  Future<UserAddressResponse> getUserAddress();

  @POST("api/address/add-address")
  Future<AddAddressResponse> getAddressRequests(
      @Body() AddressRequest addressRequest);

  @POST("api/customer/create-sell-request")
  Future<SellResponse> createSell(@Body() SellRequest sellRequest);

  @GET("api/customer/get-sell-requests/{type}")
  Future<OrderResponse> getListOrder(@Path("type") String type);

  @DELETE("api/customer/remove-sell-request/{id}")
  Future<BaseModel> removeRequest(@Path("id") int id);

  @GET("api/blog/get-blog-by-category/{id}")
  Future<BlogResponse> getBlogByCategory(@Path("id") int id);

  @GET("api/blog/get-blog-detail/{id}")
  Future<BlogDetailResponse> getBlogDetailByCategory(@Path("id") int id);

  @POST("api/notification/update-fcm-token")
  Future<BaseModel> sendFCM(@Body() TokenRequest tokenRequest);

  @GET("api/notification/get-notifications")
  Future<NotificationResponse> getNotification();

  @PUT("api/account/change-password")
  Future<BaseModel> changePass(@Body() ChangePassRequest changePassRequest);

  @DELETE("api/address/remove-address/{id}")
  Future<BaseModel> deleteAddress(@Path("id") int id);

  @DELETE("api/notification/delete-all-notification")
  Future<BaseModel> removeAllNotification();

  @DELETE("api/notification/delete-notification/{id}")
  Future<BaseModel> removenotification(@Path("id") int productId);

  @GET("api/get_system_settings")
  Future<AboutResponse> getAboutVeca();

  @GET("api/momo/denominations")
  Future<MomoDenominationsResponse> getListDenominations();

  @POST("api/momo/payout/add")
  Future<MomoResponse> createWithdrawalMomo(
      @Field('amount') int amount, @Field('phone') String phone);

  @GET("api/momo/payout/list")
  Future<MomoHistoryWithdrawalResponse> getListWithdrawalMomo();

  @DELETE("api/momo/payout/remove/{payout_id}")
  Future<BaseModel> deletePayout(@Path("payout_id") int payoutId);
}
