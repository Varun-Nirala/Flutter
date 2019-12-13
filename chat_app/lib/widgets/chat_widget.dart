import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/common.dart';
import '../models/message.dart';
import '../provider/chat_provider.dart';

class ChatWidget extends StatelessWidget {
  final String chatId; // @TODO: Instead of contact we should have a unique id

  final _msgController = TextEditingController();

  ChatWidget({@required this.chatId});

  void onMicPress() {}

  void _onSubmit(BuildContext context) {
    final String msgText = _msgController.text;

    if (msgText.isNotEmpty) {
      _msgController.clear();
      Provider.of<ChatProvider>(context).addMessage(chatId, msgText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: Consumer<ChatProvider>(
                builder: (ctx, chat, _) {
                  return ListView.builder(
                    itemCount: chat.getAllMessages(chatId).length,
                    itemBuilder: (ctx, i) {
                      return _displayTextMessage(
                          context, chat.getAllMessages(chatId)[i]);
                    },
                  );
                },
              ),
            ),
          ),
          Divider(height: 2),
          _textComposer(context),
          Divider(
            height: 5,
            color: Colors.grey[300],
            thickness: 5,
          ),
        ],
      ),
    );
  }

  Widget _displayTextMessage(BuildContext context, Message msg) {
    if (msg.ownerId == chatId) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Card(
            elevation: 2,
            child: ListTile(
              trailing: Text(msg.text),
            ),
          ),
        ],
      );
    } else {
      return Text(msg.text);
    }
  }

  Widget _textComposer(BuildContext context) {
    final totalHeight = 45.0;
    final fontSize = 18.0;
    return SizedBox(
      height: totalHeight,
      child: Row(
        children: <Widget>[
          getSizedIconButton(Icons.insert_emoticon, () {}),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 0),
              child: TextField(
                controller: _msgController,
                onSubmitted: (_) => _onSubmit(context),
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hasFloatingPlaceholder: false,
                  labelText: 'Type a message',
                ),
              ),
            ),
          ),
          getSizedIconButton(Icons.attach_file, () {}),
          getSizedIconButton(Icons.camera_alt, () {}),
          getCircularButton(Icons.mic, onMicPress),
        ],
      ),
    );
  }

  Widget getSizedIconButton(IconData iconData, Function onPress,
      [double width = 30]) {
    return SizedBox(
      width: width,
      child: IconButton(
        icon: Icon(iconData),
        onPressed: onPress,
      ),
    );
  }
}
