import 'package:flutter/material.dart';
import 'package:magic_tower_origin/config/colors.dart';

class Conversation extends StatefulWidget {
  List<String> _message = List();
  VoidCallback _onTrigger;
  String _name;

  Conversation(this._name, this._message, this._onTrigger);

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
        decoration: BoxDecoration(
            color: ColorMgr.cr666666(),
            border: Border.all(color: ColorMgr.crB57147(), width: 4)),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Container(
              width: double.infinity,
              child: Text(
                widget._name + ": " + widget._message[index],
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Text(
                ">>",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
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
