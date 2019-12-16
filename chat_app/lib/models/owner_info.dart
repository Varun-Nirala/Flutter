import 'package:flutter/foundation.dart';

class OwnerInfo {
  final String userNumber;
  final String userCountryCode;

  const OwnerInfo({@required this.userNumber, @required this.userCountryCode});

  String get number {
    return userNumber;
  }

  String get countryCode {
    return userCountryCode;
  }

  String get phoneNumber {
    return '+' + userCountryCode + userNumber;
  }
}