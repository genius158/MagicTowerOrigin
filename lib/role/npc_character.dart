import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/condition_trigger.dart';
import 'package:magic_tower_origin/role/grow_weapon_role.dart';
import 'package:magic_tower_origin/role/hero_character.dart';
import 'package:magic_tower_origin/role/prop_role.dart';
import 'package:magic_tower_origin/role/weapon_role.dart';
import 'package:magic_tower_origin/rolemanager/hero_event_logic.dart';

/// 角色 npc 各种npc
class NPC extends BaseCharacter<List<String>> implements ConditionTrigger {
  get message => abilityEntry;

  set messages(List<String> messages) {
    abilityEntry.clear();
    if (messages != null) {
      abilityEntry.addAll(messages);
    }
  }

  set message(String message) => abilityEntry.add(message);

  bool triggerThanDismiss = false;

  /// 我们可以从当前npc处获取到什么
  BaseCharacter abilityGrantRole;

  NPC(ImageRender imageRender, List<String> messages,
      BaseCharacter abilityGrantRole)
      : super(imageRender, messages) {
    this.abilityGrantRole = abilityGrantRole;
  }

  setTriggerThanDismiss() {
    triggerThanDismiss = true;
    return this;
  }

  /// 赋予英雄能力
  grant(HeroCharacter hero) {
    BaseCharacter character = abilityGrantRole;
    if (character == null || hero == null) {
      return;
    }

    if (character is PropRole) {
      hero.addEquipment(character);
      HeroEventLogic.toastProp(character);
    } else if (character is WeaponRole) {
      if (character is GrowWeaponRole) {
        hero.abilityEntry.merge(character.abilityEntry);
        HeroEventLogic.toastGrow(character);
      } else {
        hero.addEquipment(character);
        HeroEventLogic.toastWeapon(character);
      }
    }
  }

  @override
  jsonData() {
    Map<String, dynamic> jsonData = super.jsonData();
    jsonData.addAll({
      MapConvert.MESSAGE: message,
      MapConvert.TRIGGER_DISMISS: triggerThanDismiss,
    });

    if (abilityGrantRole != null) {
      jsonData.addAll({MapConvert.GRANT_ROLE: abilityGrantRole.jsonData()});
    }
    return jsonData;
  }

  @override
  void trigger() {}

}
