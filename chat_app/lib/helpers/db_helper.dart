import 'package:firebase_database/firebase_database.dart';
import 'package:contacts_service/contacts_service.dart';

import '../models/owner_info.dart';
import '../models/message.dart';

// Singleton Class
class DBHelper {
  static final DBHelper _instance = DBHelper._init();

  FirebaseDatabase _dbInstance;

  final String _dbChildUser = 'Users';
  final String _dbChildMessages = 'Messages';
  final String _dbActiveChat = 'ActiveChats';

  factory DBHelper() {
    return _instance;
  }

  DBHelper._init() {
    FirebaseDatabase().setPersistenceEnabled(true);
    _dbInstance = FirebaseDatabase.instance;
  }

  DatabaseReference getUserReference() {
    return _dbInstance.reference().child(_dbChildUser);
  }

  DatabaseReference getMessagesReference(String chatId) {
    return _dbInstance.reference().child(_dbChildMessages).child(chatId);
  }

  DatabaseReference getActiveChatsReference(String ownerId) {
    return _dbInstance.reference().child(_dbActiveChat).child(ownerId);
  }

  Future<bool> isUserRegistered(String id) async {
    DataSnapshot snapShot = await getUserReference().child(id).once();

    return snapShot.value != null;
  }

  Future<bool> isChatPresent(String ownerId, String toNumber) async {
    DataSnapshot snapShot =
        await getActiveChatsReference(ownerId).child(toNumber).once();

    return snapShot.value != null;
  }

  Future<void> addUser(OwnerInfo info) async {
    bool bRet = await isUserRegistered(info.phoneNumber);

    if (!bRet) {
      await getUserReference().child(info.phoneNumber).set(info.toMap());
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
    await getMessagesReference(chatId).push().set(msg.toMap());
  }

  Future<void> addChat(
      String ownerId, String toNumber, Map<String, dynamic> data) async {
    await getActiveChatsReference(ownerId).child(toNumber).set(data);
    await getActiveChatsReference(toNumber).child(ownerId).set(data);
  }
}
