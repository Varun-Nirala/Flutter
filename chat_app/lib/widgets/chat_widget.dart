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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50)),
                      child: TextFormField(
                        initialValue: 'Type a message',
                        showCursor: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            getCircularButton(Icon(Icons.mic), onMicPress),
          ],
        ),
      ],
    );
  }
}
