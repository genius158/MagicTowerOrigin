import 'dart:ui';

import 'package:magic_tower_origin/role/name_image_role.dart';

class ImageNode extends NameImage {
  /// 图片被切割为 4*4
  List<int> split = [4, 4];

  /// 显示图片的部分
  int index = 0;

  ImageNode(String imgPath, this.split, this.index) : super(imgPath, imgPath);

  Rect get imgRect {
    if (image == null) {
      return Rect.fromLTRB(0, 0, 1, 1);
    }

    int splitX = split[0];
    int splitY = split[1];

    int indexY = (index / splitX).floor();
    int indexX = index % splitX;

    double indexWidth = image.width / splitX;
    double indexHeight = image.height / splitY;

    Rect imgRect = new Rect.fromLTRB(
        indexWidth * (indexX),
        indexHeight * (indexY),
        indexWidth * (indexX + 1),
        indexHeight * (indexY + 1));
    return imgRect;
  }

  int getXIndex(int level) {
    return index % level;
  }

  int getYIndex(int level) {
    return (index / level).floor();
  }
}
