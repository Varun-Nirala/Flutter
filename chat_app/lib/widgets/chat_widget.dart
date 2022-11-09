import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:contacts_service/contacts_service.dart';

import '../models/owner_info.dart';
import '../helpers/common.dart';
import '../models/message.dart';
import '../provider/chat_provider.dart';
import '../provider/active_chats_provider.dart';
import '../provider/owner_info_provider.dart';

class ChatWidget extends StatefulWidget {
  final Contact othersContact;

  ChatWidget({required this.othersContact});

  String get othersNumber {
    return othersContact.phones!.first.value!.replaceAll(' ', '');
  }

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late String chatId;
  late OwnerInfo ownerInfo;
  late String ownerId;
  bool _isInit = true;

  final _msgController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      ownerInfo =
          Provider.of<OwnerInfoProvider>(context, listen: false).ownerInfo;
      ownerId = ownerInfo.phoneNumber.replaceAll(' ', '');
      chatId = Provider.of<OwnerInfoProvider>(context, listen: false)
          .createChatId(widget.othersContact);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void onMicPress() {}

  void _onSubmit(BuildContext context) {
    final String msgText = _msgController.text;

    if (msgText.isNotEmpty) {
      _msgController.clear();
      DateTime timeStamp = DateTime.now();
      Provider.of<ChatProvider>(context)
          .addMessage(chatId, ownerId, msgText, timeStamp);
      Provider.of<ActiveChatsProvider>(context)
          .addActiveChat(chatId, widget.othersNumber, msgText, timeStamp);
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
          const Divider(height: 2),
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

    if (msg.ownerId != ownerId) {
      value = EdgeInsets.only(left: 5, top: 5, bottom: 5, right: gapSize);
      alignTo = TextAlign.left;
    }

    return Card(
      elevation: 2,
      margin: value,
      child: Row(
        mainAxisAlignment: (msg.ownerId != ownerId)
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                msg.text,
                textAlign: alignTo,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 5, top: 10),
              child: Text(
                getFormattedTime(msg.dateTime.toIso8601String()),
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.start,
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
                  floatingLabelBehavior: FloatingLabelBehavior.never,
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
        onPressed: () => onPress(),
      ),
    );
  }
}
