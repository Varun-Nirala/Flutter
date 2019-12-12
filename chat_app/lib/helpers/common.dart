import 'dart:typed_data';

import 'package:flutter/material.dart';

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
    icon: const Icon(Icons.video_call),
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
