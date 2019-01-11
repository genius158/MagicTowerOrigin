import 'dart:ui' as UI show Image;

import 'package:magic_tower_origin/role/name_role.dart';

class NameImage extends Name {
  UI.Image image;
  String imgPath;

  NameImage(String name, this.imgPath) : super(name);
}
