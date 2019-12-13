import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/chat_provider.dart';
import '../models/chat.dart';
import '../helpers/common.dart';

class ChatWidget extends StatelessWidget {
  final String chatId; // @TODO: Instead of contact we should have a unique id

  const ChatWidget({@required this.chatId});

  void onMicPress() {}

  @override
  Widget build(BuildContext context) {
    final Chat chat = Provider.of<ChatProvider>(context).getChat(chatId);
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              width: double.infinity,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Text'),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          _textComposer(),
        ],
      ),
    );
  }

  Row _textComposer() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,
                labelText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.insert_emoticon),
                  onPressed: () {},
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.attach_file), onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.camera_alt), onPressed: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
        getCircularButton(Icon(Icons.mic), onMicPress),
      ],
    );
  }
}
