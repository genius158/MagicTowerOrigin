import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:magic_tower_origin/render/image_node.dart';
import 'package:magic_tower_origin/render/image_render.dart';

/// 游戏主画布，所有游戏操作渲染的窗口
class GamePainter extends CustomPainter {
  Paint _gamePaint;

  List<ImageRender> imageRenders;

  GamePainter({this.imageRenders}) {
    _gamePaint = Paint();
//    gamePaint.style = PaintingStyle.stroke;
//    gamePaint.strokeWidth = 1.0;
//    gamePaint.color = Color(0xa0dddddd);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (imageRenders == null) {
      return;
    }
    for (var imgRender in imageRenders) {
      if (imgRender == null) {
        continue;
      }
      ImageNode imageNode = imgRender.imageNode;
      if (imageNode.image == null) {
        continue;
      }
      canvas.drawImageRect(imageNode.image, imageNode.imgRect,
          imgRender.getDisplayRect(size), _gamePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
