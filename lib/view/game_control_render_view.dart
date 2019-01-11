import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_tower_origin/control/control_touch.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/view/game_painter.dart';
import 'package:rxdart/rxdart.dart';

class GameControlRenderView extends StatefulWidget {
  List<ImageRender> _imageRenders;
  ValueChanged<TouchDirect> _onDirectChange;
  ValueChanged<int> _valueChanged;

  GameControlRenderView(
      this._imageRenders, this._onDirectChange, this._valueChanged);

  @override
  State<StatefulWidget> createState() {
    return new GameControlRenderState();
  }
}

class GameControlRenderState extends State<GameControlRenderView> {
  TouchDirect direct;
  int renderTimes = 0;
  StreamSubscription renderStream;

  @override
  void initState() {
    super.initState();
    if (renderStream != null) {
      renderStream.cancel();
    }

    renderStream = Observable.periodic(Duration(milliseconds: 500)).listen((_) {
      renderTimes++;
      if (renderTimes >= 9) {
        renderTimes = 0;
      }
//      print("GameControlRenderState 11111  $renderTimes");
      if (renderTimes >= 5) {
        int tempRT = renderTimes % 5;
        if (widget._valueChanged != null) {
          widget._valueChanged(tempRT);
          setState(() {});
        }
//        print("GameControlRenderState   $tempRT");

      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    renderStream.pause();
  }


  @override
  void dispose() {
    super.dispose();
    renderStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ControlTouch(
        valueChanged: (direct) {
          widget._onDirectChange(direct);
          setState(() {
            this.direct = direct;
          });
        },
        child: new AspectRatio(
            aspectRatio: 1, //
            child: new CustomPaint(
              painter: GamePainter(imageRenders: widget._imageRenders),
            )));
  }
}
