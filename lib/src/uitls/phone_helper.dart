import 'dart:math';

import 'package:logger/logger.dart';
import 'package:phone_number/phone_number.dart';

class PhoneHelper {
  static Future<PhoneParsingModel> parsePhone(
      String rawPhone, String region) async {
    PhoneNumber _plugin = PhoneNumber();
    try {
      final parsedPhone = await _plugin.parse(rawPhone, region: region);
      final type = parsedPhone['type'];
      final e164 = parsedPhone['e164'];
      final international = parsedPhone['international'];
      final national = parsedPhone['national'];
      final country_code = parsedPhone['country_code'];
      final national_number = parsedPhone['national_number'];
      return PhoneParsingModel(
          type, e164, international, national, country_code, national_number);
    } catch (err) {
      Logger().e(e);
      return null;
    }
  }

  static Future<PhoneParsingModel> parseFullPhone(String rawPhone) async {
    PhoneNumber _plugin = PhoneNumber();
    try {
      final parsedPhone = await _plugin.parse(rawPhone);
      final type = parsedPhone['type'];
      final e164 = parsedPhone['e164'];
      final international = parsedPhone['international'];
      final national = parsedPhone['national'];
      final country_code = parsedPhone['country_code'];
      final national_number = parsedPhone['national_number'];
      return PhoneParsingModel(
          type, e164, international, national, country_code, national_number);
    } catch (err) {
      Logger().e(e);
      return null;
    }
  }
}

class PhoneParsingModel {
  dynamic type;
  dynamic e164;
  dynamic international;
  dynamic national;
  dynamic country_code;
  dynamic national_number;

  PhoneParsingModel(this.type, this.e164, this.international, this.national,
      this.country_code, this.national_number);
}
