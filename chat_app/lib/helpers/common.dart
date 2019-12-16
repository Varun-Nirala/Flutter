import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

enum eSCREEN {
  SCREEN_CAMERA,
  SCREEN_CHATS,
  SCREEN_STATUS,
  SCREEN_CALLS,
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

Future<bool> getPermissions(List<PermissionGroup> permList) async {
  Map<PermissionGroup, PermissionStatus> permissionStatus =
      await PermissionHandler().requestPermissions(permList);

  bool ret = true;

  permissionStatus.forEach((key, val) {
    if (val != PermissionStatus.granted) {
      ret = false;
    }
  });

  return ret;
}

Future<PermissionStatus> getContactPermission() async {
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted) {
    Map<PermissionGroup, PermissionStatus> permissionStatus =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.contacts]);
    return permissionStatus[PermissionGroup.contacts] ??
        PermissionStatus.unknown;
  } else {
    return permission;
  }
}

Future<PermissionStatus> getMediaPermission() async {
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.disabled) {
    Map<PermissionGroup, PermissionStatus> permissionStatus =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    return permissionStatus[PermissionGroup.storage] ??
        PermissionStatus.unknown;
  } else {
    return permission;
  }
}

void handleInvalidPermissions(PermissionStatus permissionStatus) {
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
