import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsProvider extends ChangeNotifier {
  List<Contact> _contactList = [];

  List<Contact> get contactList {
    return [..._contactList];
  }

  Contact findByName(String name) {
    return _contactList.firstWhere((contact) => contact.displayName == name);
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  Future<void> fetchAndSetContacts() async {
    try {
      PermissionStatus permissionStatus = await _getContactPermission();
      if (permissionStatus == PermissionStatus.granted) {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        _contactList = contacts.toList();
        notifyListeners();
      } else {
        _handleInvalidPermissions(permissionStatus);
      }
    } catch (error) {
      throw error;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
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
