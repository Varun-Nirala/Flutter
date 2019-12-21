import 'package:shared_preferences/shared_preferences.dart';

class OwnerInfo {
  String userNumber;
  String userCountryCode;
  String verificationId;
  String smsCode;

  String numberKey = 'userNumber';
  String countryCodeKey = 'userCountryCode';
  String idKey = 'verificationId';
  String smsCodeKey = 'smsCode';

  OwnerInfo({
    this.userNumber,
    this.userCountryCode,
    this.verificationId,
    this.smsCode,
  });

  String get phoneNumber {
    return '+' + userCountryCode + userNumber;
  }

  Map<String, dynamic> toMap() {
    return {
      numberKey: userNumber,
      countryCodeKey: userCountryCode,
      idKey: verificationId,
      smsCodeKey: smsCode,
    };
  }

  Future<void> saveToDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(numberKey, userNumber);
    await prefs.setString(countryCodeKey, userCountryCode);
    await prefs.setString(idKey, verificationId);
    await prefs.setString(smsCodeKey, smsCode);
  }

  Future<bool> loadFromDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userNumber = prefs.getString(numberKey);
    userCountryCode = prefs.getString(countryCodeKey);
    verificationId = prefs.getString(idKey);
    smsCode = prefs.getString(smsCodeKey);

    if (userNumber == null ||
        userCountryCode == null ||
        verificationId == null ||
        smsCode == null) {
      return false;
    }
    return true;
  }
}
