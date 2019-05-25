import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/map/map_info.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/prop_condition_role.dart';

/// 道具 关卡切换
class PropLevel extends PropConditionRole {
  int lastLevel;
  int curLevel;
  int offset = 1;

  PropLevel(this.offset, ImageRender imageRender, BaseEntry abilityEntry)
      : super(imageRender, abilityEntry);

  @override
  void trigger() {
    print("trigger triggertrigger $offset ${MapInfo.curLevel}");

    lastLevel = MapInfo.curLevel;
    curLevel = lastLevel += offset;
  }

  @override
  jsonData() {
    Map<String, dynamic> data = super.jsonData();
    data.addAll({"offset": offset});
    return data;
  }
}
