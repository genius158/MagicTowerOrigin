import 'package:magic_tower_origin/ability/ability_entry.dart';
import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/condition_trigger.dart';
import 'package:magic_tower_origin/role/hero_character.dart';

class NPC extends AbilityCharacter implements ConditionTrigger {
  List<String> _message = [];
  bool _triggerThanDismiss = false;

  /// 我们可以从当前npc处获取到什么
  get abilityGrant => abilityEntry;

  NPC(ImageRender imageRender, AbilityEntry abilityEntry)
      : super(imageRender, abilityEntry) {
    abilityEntry.passable = false;
  }

  putMessage(String message) {
    _message.add(message);
    return this;
  }

  putMessages(List<String> messages) {
    _message.addAll(messages);
    return this;
  }

  setTriggerThanDismiss() {
    _triggerThanDismiss = true;
    return this;
  }

  /// 赋予英雄能力
  grant(HeroCharacter hero) {
    BaseEntry _be = abilityGrant;
    if (_be == null || hero == null) {
      return;
    }

    if (_be is AbilityEntry) {
      hero.abilityEntry.merge(_be);

//    }else if(_abilityGrant is ){
    }
  }

  @override
  jsonData() {
    Map<String, dynamic> jsonData = super.jsonData();
    jsonData.addAll({
      MapConvert.MESSAGE: message,
    });
    return jsonData;
  }

  @override
  void trigger() {}

  get triggerThanDismiss => _triggerThanDismiss;

  get message => _message;

  void clearMessages() {
    _message.clear();
  }
}
