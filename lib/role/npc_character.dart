import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/name_role.dart';

class NPC extends BaseCharacter<BaseEntry> {
  List<String> _message = List();

  NPC(ImageRender imageRender, BaseEntry<Name> abilityEntry)
      : super(imageRender, abilityEntry);

  get message => _message;
}
