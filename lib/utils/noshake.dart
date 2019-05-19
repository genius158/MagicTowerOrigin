
import 'package:flutter/cupertino.dart';

class NoShark extends ClampingScrollPhysics {
  @override
  ClampingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new NoShark();
  }

  @override
  double get dragStartDistanceMotionThreshold => 1;
}