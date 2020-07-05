import 'dart:html';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

enum eSCREEN {
  SCREEN_CAMERA,
  SCREEN_CHATS,
  SCREEN_STATUS,
  SCREEN_CALLS,
}

String getFormattedTime(String time) {
  DateTime timeStamp = DateTime.parse(time);
  return DateFormat.jm().format(timeStamp);
}

IconButton getSearchIconButton(Function onpress) {
  return IconButton(
    icon: const Icon(Icons.search),
    onPressed: onpress,
    padding: const EdgeInsets.all(0),
  );
}

IconButton getMoreIconButton(Function onpress) {
  return IconButton(
    icon: const Icon(Icons.more_vert),
    onPressed: onpress,
    padding: const EdgeInsets.all(0),
  );
}

IconButton getVideoIconButton(Function onpress) {
  return IconButton(
    icon: const Icon(Icons.videocam),
    onPressed: onpress,
    padding: const EdgeInsets.all(0),
  );
}

IconButton getCallIconButton(Function onpress) {
  return IconButton(
    icon: const Icon(Icons.call),
    onPressed: onpress,
    padding: const EdgeInsets.all(0),
  );
}

CircleAvatar getCircularAvatar(Uint8List avatar) {
  return (avatar != null && avatar.isNotEmpty)
      ? CircleAvatar(backgroundImage: MemoryImage(avatar))
      : CircleAvatar(
          child: Icon(
            Icons.perm_identity,
            color: Colors.white,
            size: 35,
          ),
          backgroundColor: Colors.grey[350],
        );
}

Widget getCircularButton(IconData iconData, Function onpress) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 2, right: 5, left: 10),
    child: CircleAvatar(
      child: IconButton(
        icon: Icon(iconData),
        onPressed: onpress,
      ),
    ),
  );
}

Future<bool> getPermissions(List<Permission> permList) async {
  Map<Permission, PermissionStatus> permissionStatus =
      await permList.request();

  bool ret = true;

  permissionStatus.forEach((key, val) {
    if (val != PermissionStatus.granted) {
      ret = false;
    }
  });

  return ret;
}

Future<PermissionStatus> getContactPermission() async {
  PermissionStatus permissionStatus = await Permission.contacts.status;

  if(permissionStatus != PermissionStatus.granted || permissionStatus != PermissionStatus.permanentlyDenied)
  {
      permissionStatus = await Permission.contacts.request();
  }
  return permissionStatus;
}

Future<PermissionStatus> getMediaPermission() async {
  PermissionStatus permissionStatus = await Permission.storage.status;

  if(permissionStatus != PermissionStatus.granted || permissionStatus != PermissionStatus.permanentlyDenied)
  {
      permissionStatus = await Permission.storage.request();
  }
  return permissionStatus;
}

void handleInvalidPermissions(PermissionStatus permissionStatus) {
  if (permissionStatus == PermissionStatus.denied || permissionStatus == PermissionStatus.permanentlyDenied) {
    throw new PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to location data denied",
        details: null);
  } else if (permissionStatus == PermissionStatus.restricted) {
    throw new PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null);
  }
}
