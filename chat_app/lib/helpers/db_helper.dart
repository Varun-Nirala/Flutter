import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:contacts_service/contacts_service.dart';

import '../models/owner_info.dart';

class DBHelper {
  static const verificationKey = 'verificationId';
  static const smsCodeKey = 'smsCode';

  static Future<bool> isRegistered(String id) async {
    DataSnapshot snapShot = await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(id)
        .once();

    return snapShot.value != null;
  }

  static Future<void> addUser(OwnerInfo info) async {
    bool bRet = await isRegistered(info.phoneNumber);

    if (!bRet) {
      Map<String, String> data = {
        verificationKey: '${info.verificationId}',
        smsCodeKey: '${info.smsCode}',
      };

      FirebaseDatabase.instance.reference().child('Users').child(info.phoneNumber).set(data);
    }
  }

  static Future<List<Contact>> getAllRegistered(
      List<Contact> inContacts) async {
    List<Contact> retContacts = [];

    for (Contact contact in inContacts) {
      String phoneNumber = contact.phones.first.value;
      bool bRet = await isRegistered(phoneNumber.replaceAll(' ', ''));
      if (bRet) {
        retContacts.add(contact);
      }
    }
    return retContacts;
  }
}
