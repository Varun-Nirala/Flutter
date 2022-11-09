import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/common.dart' as common;
import '../helpers/db_helper.dart' as db;

class Contacts {
  static final Contacts _instance = Contacts._init();
  String _ownerNumber = '';
  List<Contact> _contactList = [];
  List<Contact> _registeredContactList = [];
  bool isInitialized = false;

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
    List<Contact> list = List<Contact>.from(_contactList);
    return list;
  }

  List<Contact> get registeredContactList {
    List<Contact> list = List<Contact>.from(_registeredContactList);
    return list;
  }

  Contact findByName(String name) {
    return _contactList.firstWhere((contact) => contact.displayName == name);
  }

  Contact findByNumber(String number) {
    return _contactList.firstWhere((contact) =>
        number.replaceAll(' ', '') ==
        contact.phones!.first.value!.replaceAll(' ', ''));
  }

  Future<void> fetchAndSetContacts(String ownerNumber) async {
    if (!isInitialized) {
      try {
        _ownerNumber = ownerNumber;
        PermissionStatus permissionStatus = await common.getContactPermission();
        if (permissionStatus == PermissionStatus.granted) {
          try {
            _contactList = (await ContactsService.getContacts()).toList();
            _contactList.removeWhere((Contact c) {
              return c.phones!.isEmpty;
            });
          } catch (error) {
            print('Exception Line 55 :-> $error');
          }

          try {
            _registeredContactList =
                await db.DBHelper().getAllRegisteredUser(contactList);

            _registeredContactList.removeWhere((Contact c) {
              String number = c.phones!.first.value!.replaceAll(' ', '');
              return number == ownerNumber;
            });
          } catch (error) {
            print('Exception Line 55 :-> $error');
          }

          isInitialized = true;
        } else {
          common.handleInvalidPermissions(permissionStatus);
        }
      } catch (error) {
        print('');
      }
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
