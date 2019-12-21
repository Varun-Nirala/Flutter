import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import '../models/owner_info.dart';
import '../helpers/db_helper.dart' as db;

class OwnerInfoProvider extends ChangeNotifier {
  bool authenticated = false;
  OwnerInfo _ownerInfo;

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
    await _ownerInfo.saveToDisk();

    notifyListeners();
  }

  Future<OwnerInfo> fetchAndSetOwner() async {
    _ownerInfo = OwnerInfo();
    bool bRet = await _ownerInfo.loadFromDisk();
    if (!bRet) {
      notifyListeners();
      _ownerInfo = null;
      return null;
    }
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
    chatId = (_ownerInfo.phoneNumber.compareTo(otherNumber) < 0)
        ? _ownerInfo.phoneNumber + '_' + otherNumber
        : otherNumber + '_' + _ownerInfo.phoneNumber;

    return chatId;
  }
}
