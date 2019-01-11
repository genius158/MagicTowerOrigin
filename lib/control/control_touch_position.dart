import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:magic_tower_origin/map/map_info.dart';

/// 移动位置判定
class ControlTouchPosition extends StatelessWidget {
  Offset _localOffset;
  Widget _child;

  ValueChanged<List<Offset>> _valueChanged;
  Map<String, Offset> _offsets = HashMap();

  ControlTouchPosition(this._child, this._valueChanged);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _child,
      onPanDown: (detail) {
        _offsets.clear();
        _globalToLocal(context, detail.globalPosition);
      },
      onPanUpdate: (detail) {
        _globalToLocal(context, detail.globalPosition);
      },
      onPanEnd: (_) {
        _valueChanged(_offsets.values.toList());
      },
    );
  }

  void _globalToLocal(BuildContext context, Offset globalPosition) {
    RenderBox getBox = context.findRenderObject();
    _localOffset = getBox.globalToLocal(globalPosition);

    double dx =
        (_localOffset.dx * MapInfo.sx / context.size.width).floor().toDouble();
    double dy =
        (_localOffset.dy * MapInfo.sy / context.size.height).floor().toDouble();
    dx = dx >= MapInfo.sx ? (MapInfo.sx - 1).floor() : (dx < 0 ? 0 : dx);
    dy = dy >= MapInfo.sy ? (MapInfo.sy - 1).floor() : (dy < 0 ? 0 : dy);

    _offsets.putIfAbsent("$dx$dy", () => new Offset(dx, dy));
  }
}
