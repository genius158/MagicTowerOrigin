import 'package:flutter/material.dart';
import 'package:magic_tower_origin/render/image_node.dart';
import 'package:magic_tower_origin/widget/image_view.dart';

class GameImageText extends StatelessWidget {
  EdgeInsetsGeometry padding;
  String text;
  double width;
  double height;
  ImageNode imageNode;
  double fontSize;

  GameImageText(this.imageNode, this.text,
      {this.padding, this.width, this.height, this.fontSize});

  @override
  Widget build(BuildContext context) {
//    print("GameImageTextGameImageTextGameImageText      ---------------------");
    Text tv = new Text(
      text,
      style: TextStyle(fontSize: fontSize ?? 14, color: Colors.white),
    );
    if (imageNode == null) {
      return Padding(padding: padding ?? EdgeInsets.all(0), child: tv);
    }
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          ImageView(
            imageNode,
            width: width,
            height: height,
          ),
          tv
        ],
      ),
    );
  }
}
