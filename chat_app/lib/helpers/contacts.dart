import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/common.dart' as common;
import '../helpers/db_helper.dart' as db;

class Contacts {
  static final Contacts _instance = Contacts._init();
  String _ownerNumber = '';
  List<Contact> _contactList = [];
  List<Contact> _registeredContactList = [];

  factory Contacts() {
    return _instance;
  }

  Contacts._init() {
    //
  }

  String get ownerNumber {
    return _ownerNumber;
  }

  List<Contact> get contactList {
    return [..._contactList];
  }

  List<Contact> get registeredContactList {
    return [..._registeredContactList];
  }

  Contact findByName(String name) {
    return _contactList.firstWhere((contact) => contact.displayName == name);
  }

  Contact findByNumber(String number) {
    return _contactList.firstWhere((contact) =>
        number.replaceAll(' ', '') ==
        contact.phones.first.value.replaceAll(' ', ''));
  }

  Future<void> fetchAndSetContacts(String ownerNumber) async {
    try {
      _ownerNumber = ownerNumber;
      PermissionStatus permissionStatus = await common.getContactPermission();
      if (permissionStatus == PermissionStatus.granted) {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        _contactList = contacts.toList();

        _registeredContactList =
            await db.DBHelper().getAllRegisteredUser(contactList);

        _registeredContactList.removeWhere((Contact c) {
          String number = c.phones.first.value.replaceAll(' ', '');
          return number == ownerNumber;
        });
      } else {
        common.handleInvalidPermissions(permissionStatus);
      }
    } catch (error) {
      throw error;
    }
  }
}

// // Get all contacts on device
// Iterable<Contact> contacts = await ContactsService.getContacts();

// // Get all contacts without thumbnail (faster)
// Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);

// // Android only: Get thumbnail for an avatar afterwards (only necessary if `withThumbnails: false` is used)
// Uint8List avatar = await ContactsService.getAvatar(contact);

// // Get contacts matching a string
// Iterable<Contact> johns = await ContactsService.getContacts(query : "john");

// // Add a contact
// // The contact must have a firstName / lastName to be successfully added
// await ContactsService.addContact(newContact);

// // Delete a contact
// // The contact must have a valid identifier
// await ContactsService.deleteContact(contact);

// // Update a contact
// // The contact must have a valid identifier
// await ContactsService.updateContact(contact);