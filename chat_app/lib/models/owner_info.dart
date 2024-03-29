import 'package:shared_preferences/shared_preferences.dart';

class OwnerInfo {
  String userNumber;
  String userCountryCode;

  String _numberKey = 'userNumber';
  String _countryCodeKey = 'userCountryCode';

  OwnerInfo({
    this.userNumber = "",
    this.userCountryCode = "",
  });

  String get phoneNumber {
    return '+' + userCountryCode + userNumber;
  }

  Map<String, dynamic> toMap() {
    return {
      _numberKey: userNumber,
      _countryCodeKey: userCountryCode,
    };
  }

  Future<void> saveToDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_numberKey, userNumber);
    await prefs.setString(_countryCodeKey, userCountryCode);
  }

  Future<bool> loadFromDisk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_numberKey) && prefs.containsKey(_countryCodeKey)) {
      userNumber = prefs.getString(_numberKey)!;
      userCountryCode = prefs.getString(_countryCodeKey)!;
      return true;
    }
    return false;
  }
}
