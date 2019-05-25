
import 'package:flutter/cupertino.dart';

/// 滚动控件屏蔽抖动
class NoShark extends ClampingScrollPhysics {
  @override
  ClampingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new NoShark();
  }

  @override
  double get dragStartDistanceMotionThreshold => 1;
}