import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/condition_trigger.dart';
import 'package:magic_tower_origin/role/name_role.dart';

class NPC extends BaseCharacter<BaseEntry> implements ConditionTrigger {
  List<String> _message = [];
  bool _triggerThanDismiss = false;

  NPC(ImageRender imageRender, BaseEntry<Name> abilityEntry)
      : super(imageRender, abilityEntry) {
    abilityEntry.passable = false;
  }

  putMessage(String message) {
    _message.add(message);
    return this;
  }

  setTriggerThanDismiss() {
    _triggerThanDismiss = true;
    return this;
  }

  @override
  void trigger() {}

  get triggerThanDismiss => _triggerThanDismiss;

  get message => _message;
}
