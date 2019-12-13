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
                  final gapSize = MediaQuery.of(context).size.width * 0.40;
                  List<Message> msgList = chat.getAllMessages(chatId);
                  return ListView.builder(
                    itemCount: msgList.length,
                    itemBuilder: (ctx, i) {
                      return _displayTextMessage(context, gapSize, msgList[i]);
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

  Widget _displayTextMessage(
      BuildContext context, double gapSize, Message msg) {
    EdgeInsets value =
        EdgeInsets.only(left: gapSize, top: 5, bottom: 5, right: 5);
    TextAlign alignTo = TextAlign.right;

    if (msg.ownerId != chatId) {
      value = EdgeInsets.only(left: 5, top: 5, bottom: 5, right: gapSize);
      alignTo = TextAlign.left;
    }

    return Card(
      elevation: 2,
      margin: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                msg.text,
                textAlign: alignTo,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
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
