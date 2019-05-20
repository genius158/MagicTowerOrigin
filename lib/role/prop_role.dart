import 'package:magic_tower_origin/ability/prop_entry.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/base_character.dart';

class PropRole extends BaseCharacter<PropEntry> {
  PropRole(ImageRender imageRender, PropEntry abilityEntry)
      : super(imageRender, abilityEntry);

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

  @override
  BaseCharacter clone() {
    PropRole character = new PropRole(imageRender, abilityEntry.clone());
    character.type = type;
    character.name = name;
    return character;
  }
}
