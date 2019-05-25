import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/ability_character.dart';

/// 角色 英雄
class HeroCharacter extends AbilityCharacter {
  HeroCharacter(ImageRender imageRender, BaseEntry abilityEntry)
      : super(imageRender, abilityEntry);

  @override
  jsonData() {
    Map<String, dynamic> jsonData = super.jsonData();
    jsonData.addAll({
      MapConvert.PX: imageRender.position[0],
      MapConvert.PY: imageRender.position[1],
    });
    return jsonData;
  }


}
