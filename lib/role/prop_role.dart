import 'package:magic_tower_origin/ability/prop_entry.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/base_character.dart';

class PropRole extends BaseCharacter<PropEntry> {
  bool needDell = true;

  PropRole(ImageRender imageRender, PropEntry abilityEntry)
      : super(imageRender, abilityEntry);

  ///标记和判断道具是否执行过了
  ///传入 isDell 则是做标记
  static flagProp(propRole, {bool needDell}) {
    if (needDell == null) {
      return (propRole is PropRole) && propRole.needDell;
    }
    if (propRole != null && (propRole is PropRole)) {
      propRole.needDell = needDell;
    }
  }

  @override
  jsonData() {
    Map<String, dynamic> jsonData = super.jsonData();
    jsonData.addAll({
      MapConvert.TIMES: abilityEntry.times,
      MapConvert.PROP_TYPE: abilityEntry.propType,
    });
    print("PropRole jsonData   $jsonData");
    return jsonData;
  }
}
