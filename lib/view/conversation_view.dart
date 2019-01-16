import 'package:flutter/material.dart';
import 'package:magic_tower_origin/config/colors.dart';

class Conversation extends StatefulWidget {
  List<String> _message = List();
  VoidCallback _onTrigger;

  Conversation(this._message, this._onTrigger);

  @override
  State<StatefulWidget> createState() {
    return _ConversationState();
  }
}

class _ConversationState extends State<Conversation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: Container(
        color: ColorMgr.crB57147(),
        child: Text(widget._message[index]),
      ),
      onTap: () {
        nextMessage(context);
      },
    );
  }

  nextMessage(context) {
    final tempIndex = ++index;
    if (tempIndex < widget._message.length) {
      setState(() {});
      return;
    }
    Navigator.pop(context);
    widget._onTrigger();
  }
}
