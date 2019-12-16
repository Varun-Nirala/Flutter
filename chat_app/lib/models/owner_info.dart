import 'package:flutter/foundation.dart';

class OwnerInfo {
  final String userNumber;
  final String userCountryCode;
  final String verificationId;
  final String smsCode;

  const OwnerInfo(
      {@required this.userNumber,
      @required this.userCountryCode,
      @required this.verificationId,
      @required this.smsCode});

  String get phoneNumber {
    return '+' + userCountryCode + userNumber;
  }
}
