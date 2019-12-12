import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/chat_provider.dart';
import '../models/chat.dart';

class ChatWidget extends StatelessWidget {
  final String chatId;  // @TODO: Instead of contact we should have a unique id

  const ChatWidget({@required this.chatId});

  @override
  Widget build(BuildContext context) {
    final Chat chat = Provider.of<ChatProvider>(context, listen: false).getChat(chatId);
    return Column(
      children: <Widget>[
        Container(
          height: 500,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ListView.builder(
              itemCount: chat.messages.length,
              itemBuilder: (ctx, i) {
                return Card(
                  child: Text(chat.messages[i].text),
                );
              },
            ),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
