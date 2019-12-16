import 'package:flutter/material.dart';

import '../models/owner_info.dart';

class OwnerInfoProvider extends ChangeNotifier {
  OwnerInfo _ownerInfo;

  OwnerInfo setUserInfo(String number, String countryCode) {
    _ownerInfo = OwnerInfo(userNumber: number, userCountryCode: countryCode);
    notifyListeners();
    return ownerInfo;
  }

  OwnerInfo get ownerInfo {
    return OwnerInfo(
        userNumber: _ownerInfo.userNumber,
        userCountryCode: _ownerInfo.countryCode);
  }
}
