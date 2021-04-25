import 'dart:convert';

import 'package:veca_customer/src/models/basemodel.dart';


class AddressResponse extends BaseResponse {
  bool success;
  String message;
  List<Address> data;

  AddressResponse({
    this.success,
    this.message,
    this.data,
  });

  factory AddressResponse.fromRawJson(String str) =>
      AddressResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      AddressResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Address>.from(json["data"].map((x) => Address.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
      };

  @override
  bool hasData() {
    return data != null;
  }
}

class Address {
  int id;
  String addressType;
  String addressTitle;
  String addressLine1;
  String city;
  String zipCode;
  CountryData country;
  ProvincesAddress provinces;
  District district;
  Wards wards;
  String phone;
  final bool isDeleting;
  final bool isSelect;

  Address({
    this.id,
    this.addressType,
    this.addressTitle,
    this.addressLine1,
    this.city,
    this.zipCode,
    this.country,
    this.provinces,
    this.district,
    this.wards,
    this.phone,
    this.isDeleting,
    this.isSelect,
  });

  Address copyWith(
          {int id,
          String addressType,
          String addressTitle,
          String addressLine1,
          String city,
          String zipCode,
          CountryData country,
          ProvincesAddress provinces,
          District district,
          Wards wards,
          String phone,
          bool isDeleting,
          bool isSelect}) =>
      Address(
          id: id ?? this.id,
          addressType: addressType ?? this.addressType,
          addressTitle: addressTitle ?? this.addressTitle,
          addressLine1: addressLine1 ?? this.addressLine1,
          city: city ?? this.city,
          zipCode: zipCode ?? this.zipCode,
          country: country ?? this.country,
          provinces: provinces ?? this.provinces,
          district: district ?? this.district,
          wards: wards ?? this.wards,
          phone: phone ?? this.phone,
          isDeleting: isDeleting ?? this.isDeleting,
          isSelect: isSelect ?? this.isSelect);

  getFullAddress() {
    return addressLine1 +
        ", " +
        country.name +
        ", " +
        provinces.name +
        ", " +
        district.name +
        ", " +
        wards.name;
  }

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      id: json["id"] == null ? null : json["id"],
      addressType: json["address_type"] == null ? "" : json["address_type"],
      addressTitle: json["address_title"] == null ? "" : json["address_title"],
      addressLine1:
          json["address_line_1"] == null ? "" : json["address_line_1"],
      city: json["city"] == null ? "" : json["city"],
      zipCode: json["zip_code"] == null ? "" : json["zip_code"],
      country:
          json["country"] == null ? null : CountryData.fromJson(json["country"]),
      provinces: json["province"] == null
          ? null
          : ProvincesAddress.fromJson(json["province"]),
      district:
          json["district"] == null ? null : District.fromJson(json["district"]),
      wards: json["ward"] == null ? null : Wards.fromJson(json["ward"]),
      phone: json["phone"] == null ? "" : json["phone"],
      isDeleting: false,
      isSelect: false);

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "address_type": addressType == null ? null : addressType,
        "address_title": addressTitle == null ? null : addressTitle,
        "address_line_1": addressLine1 == null ? null : addressLine1,
        "city": city == null ? null : city,
        "zip_code": zipCode == null ? null : zipCode,
        "country": country == null ? null : country.toJson(),
        "province": provinces == null ? null : provinces.toJson(),
        "district": district == null ? null : district.toJson(),
        "ward": wards == null ? null : wards.toJson(),
        "phone": phone == null ? null : phone,
      };
}

class CountryData {
  int id;
  String name;
  String iso31662;
  String countryCode;

  CountryData({
    this.id,
    this.name,
    this.iso31662,
    this.countryCode,
  });

  factory CountryData.fromRawJson(String str) => CountryData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        iso31662: json["iso_3166_2"] == null ? null : json["iso_3166_2"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "iso_3166_2": iso31662 == null ? null : iso31662,
        "country_code": countryCode == null ? null : countryCode,
      };
}

class ProvincesAddress {
  int id;
  String name;
  int countryId;

  ProvincesAddress({
    this.id,
    this.name,
    this.countryId,
  });

  factory ProvincesAddress.fromRawJson(String str) =>
      ProvincesAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProvincesAddress.fromJson(Map<String, dynamic> json) =>
      ProvincesAddress(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        countryId: json["country_id"] == null ? null : json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "country_id": countryId == null ? null : countryId,
      };
}

class District {
  int id;
  String name;
  int provinceId;

  District({
    this.id,
    this.name,
    this.provinceId,
  });

  factory District.fromRawJson(String str) => District.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    provinceId: json["province_id"] == null ? null : json["province_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "province_id": provinceId == null ? null : provinceId,
  };
}

class Wards {
  int id;
  String name;
  int districtId;

  Wards({
    this.id,
    this.name,
    this.districtId,
  });

  factory Wards.fromRawJson(String str) => Wards.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Wards.fromJson(Map<String, dynamic> json) => Wards(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    districtId: json["district_id"] == null ? null : json["district_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "district_id": districtId == null ? null : districtId,
  };
}

