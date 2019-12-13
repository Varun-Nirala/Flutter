import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/chat_provider.dart';
import '../models/chat.dart';
import '../helpers/common.dart';

class ChatWidget extends StatelessWidget {
  final String chatId; // @TODO: Instead of contact we should have a unique id
  
  ChatWidget({@required this.chatId});

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
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Text'),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          _textComposer(context),
          Divider(height: 5),
        ],
      ),
    );
  }

  Widget _textComposer(BuildContext context) {
    final totalHeight = 45.0;
    final fontSize = 18.0;
    return SizedBox(
      height: totalHeight,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 35,
            child: IconButton(
              padding: EdgeInsets.only(left: 5, right: 5),
              icon: const Icon(Icons.insert_emoticon),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                border: InputBorder.none,
                hasFloatingPlaceholder: false,
                labelText: 'Type a message',
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {},
            ),
          ),
          getCircularButton(Icon(Icons.mic), onMicPress),
        ],
      ),
    );
  }
}
