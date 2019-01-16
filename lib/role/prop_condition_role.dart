import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/condition_trigger.dart';
import 'package:magic_tower_origin/role/prop_role.dart';

class PropConditionRole extends PropRole implements ConditionTrigger {
  PropConditionRole(ImageRender imageRender, BaseEntry abilityEntry)
      : super(imageRender, abilityEntry);

  @override
  void trigger() {}
}
