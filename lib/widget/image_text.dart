import 'package:flutter/material.dart';

class ImageText extends StatelessWidget {
  EdgeInsetsGeometry padding;

  String _text;
  String _img;
  double width;
  double height;
  Color color;

  ImageText(this._img, this._text,
      {this.padding, this.width, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    Text tv = new Text(
      _text,
      style: TextStyle(fontSize: 14, color: color ?? Colors.white),
    );
    if (_img == null) {
      return Padding(padding: padding ?? EdgeInsets.all(0), child: tv);
    }
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          Image.asset(
            _img,
            width: width ?? 16,
            height: height ?? 16,
          ),
          tv
        ],
      ),
    );
  }
}
