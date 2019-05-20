import 'package:magic_tower_origin/ability/ability_entry.dart';
import 'package:magic_tower_origin/ability/prop_entry.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/prop_role.dart';
import 'package:magic_tower_origin/role/weapon_role.dart';

class AbilityCharacter extends BaseCharacter<AbilityEntry> {
  List<BaseCharacter> equipment;

  WeaponRole attackWeapon;
  WeaponRole defendWeapon;

  List<WeaponRole> getWeapons() {
    List<WeaponRole> wrs = List();
    if (equipment == null) {
      return wrs;
    }
    for (BaseCharacter bc in equipment) {
      if (bc is WeaponRole) {
        wrs.add(bc);
      }
    }
    return wrs;
  }

  List<PropRole> getProps() {
    List<PropRole> wrs = List();
    if (equipment == null) {
      return wrs;
    }
    for (BaseCharacter bc in equipment) {
      if (bc is PropRole) {
        wrs.add(bc);
      }
    }
    return wrs;
  }

  AbilityCharacter setAttackWeapon(WeaponRole attackWeapon) {
    this.attackWeapon = attackWeapon;
    addEquipment(attackWeapon);
    return this;
  }

  AbilityCharacter setDefendWeapon(WeaponRole defendWeapon) {
    this.defendWeapon = defendWeapon;
    addEquipment(defendWeapon);
    return this;
  }

  addEquipment(BaseCharacter ni) {
    if (equipment == null) {
      equipment = new List();
    }
    if (ni is WeaponRole && equipment.contains(ni)) {
      return;
    }

    for (var we in equipment) {
      if (we.type == ni.type) {
        if (we.abilityEntry is PropEntry) {
          we.abilityEntry.merge(ni.abilityEntry);
          return;
        }
        equipment.remove(we);
        break;
      }
    }

    if (ni is PropRole) {
      ni = ni.clone();
    }
    equipment.add(ni);
  }

  AbilityEntry getAbilityWithWeapon() {
    AbilityEntry ability = new AbilityEntry();
    ability.merge(abilityEntry);

    if (attackWeapon != null) {
      ability.merge((attackWeapon).abilityEntry);
    }
    if (defendWeapon != null) {
      ability.merge((defendWeapon).abilityEntry);
    }

    return ability;
  }

  @override
  jsonData() {
    Map<String, dynamic> jsonData = super.jsonData();
    var abilityJson = {
      "life": abilityEntry.life,
      "attack": abilityEntry.attack,
      "defend": abilityEntry.defend,
      "money": abilityEntry.money,
      "experience": abilityEntry.experience,
      "yKey": abilityEntry.yKey,
      "bKey": abilityEntry.bKey,
      "rKey": abilityEntry.rKey
    };
    jsonData.addAll(abilityJson);

    if (equipment != null) {
      jsonData.addAll({
        "equipment": equipment.map((w) {
          return w.jsonData();
        }).toList(),
        "attackWeapon": attackWeapon.jsonData(),
        "defendWeapon": defendWeapon.jsonData()
      });
    }
    return jsonData;
  }

  AbilityCharacter(ImageRender imageRender, AbilityEntry abilityEntry)
      : super(imageRender, abilityEntry);
}
