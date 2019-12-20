import 'package:firebase_database/firebase_database.dart';
import 'package:contacts_service/contacts_service.dart';

import '../models/owner_info.dart';
import '../models/message.dart';

// Singleton Class
class DBHelper {
  static final DBHelper _instance = DBHelper._init();
  final _verificationKey = 'verificationId';
  final _smsCodeKey = 'smsCode';
  FirebaseDatabase _dbInstance;

  final String _dbChildUser = 'Users';
  final String _dbChildMessages = 'Messages';

  factory DBHelper() {
    return _instance;
  }

  DBHelper._init() {
    _dbInstance = FirebaseDatabase.instance;
  }

  Future<bool> isUserRegistered(String id) async {
    DataSnapshot snapShot =
        await _dbInstance.reference().child(_dbChildUser).child(id).once();

    return snapShot.value != null;
  }

  Future<void> addUser(OwnerInfo info) async {
    bool bRet = await isUserRegistered(info.phoneNumber);

    if (!bRet) {
      Map<String, String> data = {
        _verificationKey: '${info.verificationId}',
        _smsCodeKey: '${info.smsCode}',
      };
      _dbInstance
          .reference()
          .child(_dbChildUser)
          .child(info.phoneNumber)
          .set(data);
    }
  }

  Future<List<Contact>> getAllRegisteredUser(List<Contact> inContacts) async {
    List<Contact> retContacts = [];

    for (Contact contact in inContacts) {
      String phoneNumber = contact.phones.first.value;
      bool bRet = await isUserRegistered(phoneNumber.replaceAll(' ', ''));
      if (bRet) {
        retContacts.add(contact);
      }
    }
    return retContacts;
  }

  Future<void> addMessage(String chatId, Message msg) async {
    await _dbInstance
        .reference()
        .child(_dbChildMessages)
        .child(chatId)
        .set(msg.text);
  }
}
