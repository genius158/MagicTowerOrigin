import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_tower_origin/control/control_touch_position.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/view/game_painter.dart';
import 'package:rxdart/rxdart.dart';

/// 关卡自定义界面
class GameDiyRenderView extends StatefulWidget {
  List<ImageRender> _imageRenders;

  ValueChanged<List<Offset>> _valueChanged;
  PublishSubject _subject;

  GameDiyRenderView(
      this._imageRenders, this._valueChanged, this._subject);

  @override
  State<StatefulWidget> createState() {
    return new _GameDiyRenderState();
  }
}

class _GameDiyRenderState extends State<GameDiyRenderView> {
  StreamSubscription _subscriptionSetState;

  @override
  void initState() {
    super.initState();
    _subscriptionSetState = widget._subject.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptionSetState.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("GameDiyRenderView   --------------------------------");
    return ControlTouchPosition(
        AspectRatio(
            aspectRatio: 1, //
            child: new CustomPaint(
              painter: GamePainter(imageRenders: widget._imageRenders),
            )),
        widget._valueChanged);
  }
}
