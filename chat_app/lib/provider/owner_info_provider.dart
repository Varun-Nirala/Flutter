import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contacts_service/contacts_service.dart';

import '../models/owner_info.dart';
import '../helpers/db_helper.dart' as db;

class OwnerInfoProvider extends ChangeNotifier {
  bool authenticated = false;
  OwnerInfo _ownerInfo;

  String numberKey = 'phoneNumberKey';
  String countryCodeKey = 'countryCodeKey';
  String idKey = 'VerificationIdKey';
  String smsCodeKey = 'smsCodeKey';

  bool get isAuthenticated {
    return authenticated;
  }

  Future<void> setUserInfo(String number, String countryCode,
      String verificationId, String smsCode, bool val) async {
    _ownerInfo = OwnerInfo(
      userNumber: number,
      userCountryCode: countryCode,
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await db.DBHelper().addUser(_ownerInfo);

    authenticated = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(numberKey, number);
    await prefs.setString(countryCodeKey, countryCode);
    await prefs.setString(idKey, verificationId);
    await prefs.setString(smsCodeKey, smsCode);
    notifyListeners();
  }

  Future<OwnerInfo> fetchAndSetOwner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString(numberKey);
    String countryCode = prefs.getString(countryCodeKey);
    String verificationId = prefs.getString(idKey);
    String smsCode = prefs.getString(smsCodeKey);

    _ownerInfo = OwnerInfo(
      userNumber: number,
      userCountryCode: countryCode,
      verificationId: verificationId,
      smsCode: smsCode,
    );
    notifyListeners();
    return _ownerInfo;
  }

  OwnerInfo get ownerInfo {
    return _ownerInfo;
  }

  String createChatId(Contact othersContact) {
    String otherNumber = othersContact.phones.first.value.replaceAll(' ', '');
    String chatId;
    // Chat id is smaller number _ bigger number
    chatId =
        (_ownerInfo.phoneNumber.compareTo(otherNumber) < 0)
            ? _ownerInfo.phoneNumber + '_' + otherNumber
            : otherNumber + '_' + _ownerInfo.phoneNumber;

    return chatId;
  }
}
