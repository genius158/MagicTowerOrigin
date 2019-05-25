import 'package:flutter/material.dart';
import 'package:magic_tower_origin/render/image_node.dart';

class ImageView extends StatelessWidget {
  ImageNode imageNode;
  double width;
  double height;

  ImageView(this.imageNode, {this.width = 20, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: new CustomPaint(
        painter: Painter(imageNode),
      ),
    );
  }
}

class Painter extends CustomPainter {
  Paint gamePaint;
  ImageNode imageNode;

  Painter(this.imageNode) {
    gamePaint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
//    print("ImageView    $canvas   $size    $imageNode");
    if (imageNode == null || imageNode.image == null) {
      return;
    }
    canvas.drawImageRect(imageNode.image, imageNode.imgRect,
        Rect.fromLTRB(0, 0, size.width, size.height), gamePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
