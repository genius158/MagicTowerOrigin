import 'package:flutter/material.dart';

class ImageText extends StatelessWidget {
  EdgeInsetsGeometry padding;

  String text;
  String img;
  double width;
  double height;
  Color color;

  ImageText(this.img, this.text,
      {this.padding, this.width, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    Text tv = new Text(
      text,
      style: TextStyle(fontSize: 14, color: color ?? Colors.white),
    );
    if (img == null) {
      return Padding(padding: padding ?? EdgeInsets.all(0), child: tv);
    }
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: Row(
        children: <Widget>[
          Image.asset(
            img,
            width: width ?? 16,
            height: height ?? 16,
          ),
          tv
        ],
      ),
    );
  }
}
