import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magic_tower_origin/datacenter/game_provider.dart';
import 'package:magic_tower_origin/map/map_info.dart';
import 'package:rxdart/rxdart.dart';

/// 触摸移动处理
class ControlTouch extends StatefulWidget {
  Widget child;
  ValueChanged<TouchDirect> valueChanged;

  ControlTouch({this.child, this.valueChanged, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ControlTouchState();
  }
}

class _ControlTouchState extends State<ControlTouch> {
  // 返回点击的位置
  TouchDirect _direct = TouchDirect.none;
  StreamSubscription _changedSubscription;
  Offset _localOffset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onPanDown: (detail) {
        _globalToLocal(context, detail.globalPosition);
      },
      onPanUpdate: (detail) {
        _globalToLocal(context, detail.globalPosition);
      },
      onPanEnd: (detail) {
        _cancelSubscribeChange();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("ControlTouch2           dispose ----------------");
    _cancelSubscribeChange();
  }

  @override
  void deactivate() {
    super.deactivate();
    _cancelSubscribeChange();
  }

  /// 计算相对自身的点击位置
  void _globalToLocal(BuildContext context, Offset globalPosition) {
    RenderBox getBox = context.findRenderObject();
    _localOffset = getBox.globalToLocal(globalPosition);
    if (_changedSubscription == null) {
      _directChange();
    }
  }

  void _directChange() {
    _determineDirect();
    _changedSubscription =
        Observable.timer(null, Duration(milliseconds: 300)).listen((_) {
      _changedSubscription =
          Observable.periodic(Duration(milliseconds: 50)).listen((_) {
        _determineDirect();
      });
    });
  }

  void _cancelSubscribeChange() {
    _direct = TouchDirect.none;
    if (_changedSubscription != null) {
      _changedSubscription.cancel();
      _changedSubscription = null;
    }
  }

  void _determineDirect() {
    var ac = GameProvider.ofHero(context).abilityCharacter;
    if (ac == null) {
      return;
    }
    final position = ac.imageRender.position;

    final local = new Offset(
        (_localOffset.dx * MapInfo.sx / context.size.width).floor().toDouble(),
        (_localOffset.dy * MapInfo.sy / context.size.height)
            .floor()
            .toDouble());
    if ((local.dx - position[0]).abs() > (local.dy - position[1]).abs()) {
      if (local.dx < position[0]) {
        _direct = TouchDirect.left;
      } else if (local.dx > position[0]) {
        _direct = TouchDirect.right;
      } else {
        _direct = TouchDirect.none;
      }
    } else if ((local.dx - position[0]).abs() <
        (local.dy - position[1]).abs()) {
      if (local.dy < position[1]) {
        _direct = TouchDirect.top;
      } else if (local.dy > position[1]) {
        _direct = TouchDirect.bottom;
      } else {
        _direct = TouchDirect.none;
      }
    } else {
      _direct = TouchDirect.none;
    }

    if (widget.valueChanged != null) {
      widget.valueChanged(_direct);
    }
  }
}

enum TouchDirect { left, right, top, bottom, none }
