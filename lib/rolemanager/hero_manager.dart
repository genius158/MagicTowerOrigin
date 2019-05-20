import 'package:magic_tower_origin/ability/ability_entry.dart';
import 'package:magic_tower_origin/control/control_touch.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/hero_character.dart';
import 'package:magic_tower_origin/rolemanager/base_manager.dart';

/// 英雄管理
class HeroManager extends BaseManager<HeroCharacter, AbilityEntry> {
  HeroCharacter hero;

  /// 位置重设
  positionReset(List<BaseCharacter> cs) {
    return cs;
  }

  void listReady() {
    characters = [null];
  }

  onLoad(BaseCharacter bc) {
    print("_heroManager.onLoad()      _heroManager.onLoad()");

    if (hero == null) {
      hero = bc;
    }
  }

  HeroCharacter getCharacter(int px, int py) {
    return hero;
  }

  void dispose() {
    hero = null;
  }

  bool compare(AbilityCharacter character) {
    if (hero == null) {
      return false;
    }
    AbilityEntry heroAWW = hero.getAbilityWithWeapon();
    AbilityEntry heroAE = hero.abilityEntry.clone();
    AbilityEntry enemyAWW = character.getAbilityWithWeapon();

    bool attacked = heroAE
        .setAttack(heroAWW.attack)
        .setDefend(heroAWW.defend)
        .compare(character.abilityEntry
            .clone()
            .setAttack(enemyAWW.attack)
            .setDefend(enemyAWW.defend));

    hero.abilityEntry = heroAE
        .setAttack(hero.abilityEntry.attack)
        .setDefend(hero.abilityEntry.defend);
    return attacked;
  }

  void imageIndexSet(TouchDirect direct) {
    if (hero == null) {
      return;
    }
    switch (direct) {
      case TouchDirect.bottom:
        hero.imageRender.imageIndex = 0;
        break;
      case TouchDirect.left:
        hero.imageRender.imageIndex = 1;
        break;
      case TouchDirect.top:
        hero.imageRender.imageIndex = 2;
        break;
      case TouchDirect.right:
        hero.imageRender.imageIndex = 3;
        break;
      case TouchDirect.none:
    }
  }

  void cutProp(int type) {
    if (hero == null) {
      return;
    }
    for (var pr in hero.getProps()) {
      if (pr.abilityEntry.propType == type) {
        var times = --pr.abilityEntry.times;
        print("cutPropcutPropcutPropcutProp    $times"+"   "+pr.jsonData().toString());
        if (times <= 0) {
          hero.equipment.remove(pr);
          break;
        }
      }
    }
  }
}

