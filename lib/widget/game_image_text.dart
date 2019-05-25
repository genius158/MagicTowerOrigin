import 'package:flutter/material.dart';
import 'package:magic_tower_origin/render/image_node.dart';
import 'package:magic_tower_origin/widget/image_view.dart';

/// 区别与ImageView 图片资源来自资源库，图片显示需要一个加载过程
class GameImageText extends StatelessWidget {
  EdgeInsetsGeometry padding;
  String _text;
  double width;
  double height;
  double fontSize;
  ImageNode _imageNode;

  GameImageText(this._imageNode, this._text,
      {this.padding, this.width, this.height, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
//    print("GameImageTextGameImageTextGameImageText      ---------------------");
    Text tv = new Text(
      _text,
      style: TextStyle(fontSize: fontSize, color: Colors.white),
    );
    if (_imageNode == null) {
      return Padding(padding: padding ?? EdgeInsets.all(0), child: tv);
    }
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          ImageView(
            _imageNode,
            width: width,
            height: height,
          ),
          tv
        ],
      ),
    );
  }
}
