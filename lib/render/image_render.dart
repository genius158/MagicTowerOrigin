import 'dart:ui';

import 'package:magic_tower_origin/map/map_info.dart';
import 'package:magic_tower_origin/render/image_node.dart';

class ImageRender {
  /// 图片节点
  List<ImageNode> imageNodes;

  int imageIndex = 0;

  /// 渲染位置
  List<int> position = [null, null];

  /// 均分数量
  List<int> split = [MapInfo.sx, MapInfo.sy];

  ImageRender(List<ImageNode> imageNodes) {
    this.imageNodes = imageNodes;
  }

  ImageNode getImageNode() {
    return imageNodes[imageIndex >= imageNodes.length ? 0 : imageIndex];
  }

  ImageRender setPosition(int px, int py) {
    position[0] = px;
    position[1] = py;
    return this;
  }

  Rect getDisplayRect(Size size) {
    int px = position[0] ?? 0;
    int py = position[1] ?? 0;

    double width = size.width / split[0];
    double height = size.height / split[1];

    Rect displayRect = new Rect.fromLTRB(
        px * width, py * height, (px + 1) * width, (py + 1) * height);
//    print(displayRect);
    return displayRect;
  }

  ImageRender setImageIndex(int index) {
    imageIndex = index;
    return this;
  }
}
