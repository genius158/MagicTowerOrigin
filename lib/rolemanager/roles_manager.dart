import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/rolemanager/base_manager.dart';

/// 除英雄外，其他角色管理
class RolesManager extends BaseManager<BaseCharacter, BaseEntry> {
  /// 角色动画效果,更改图片的显示角标
  void imageIndex(int value) {
    if (characters == null) {
      return;
    }
    for (var rows in characters) {
      for (var ct in rows) {
        if (ct == null) {
          continue;
        }
        int imageCount = ct.imageRender.imageNodes.length;
        ct.imageRender.imageIndex = value >= imageCount ? 0 : value;
//        print("RolesManager   ${ ct.imageRender.imageIndex}");
      }
    }
  }
}
