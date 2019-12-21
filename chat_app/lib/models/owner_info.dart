import 'package:shared_preferences/shared_preferences.dart';

class OwnerInfo {
  String userNumber;
  String userCountryCode;
  String verificationId;
  String smsCode;

  String _numberKey = 'userNumber';
  String _countryCodeKey = 'userCountryCode';
  String _idKey = 'verificationId';
  String _smsCodeKey = 'smsCode';

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
      _numberKey: userNumber,
      _countryCodeKey: userCountryCode,
      _idKey: verificationId,
      _smsCodeKey: smsCode,
    };
  }

  Future<void> saveToDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_numberKey, userNumber);
    await prefs.setString(_countryCodeKey, userCountryCode);
    await prefs.setString(_idKey, verificationId);
    await prefs.setString(_smsCodeKey, smsCode);
  }

  Future<bool> loadFromDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userNumber = prefs.getString(_numberKey);
    userCountryCode = prefs.getString(_countryCodeKey);
    verificationId = prefs.getString(_idKey);
    smsCode = prefs.getString(_smsCodeKey);

    if (userNumber == null ||
        userCountryCode == null ||
        verificationId == null ||
        smsCode == null) {
      return false;
    }
    return true;
  }
}
