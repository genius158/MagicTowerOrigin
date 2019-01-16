import 'package:flutter/cupertino.dart';
import 'package:magic_tower_origin/control/control_touch.dart';
import 'package:magic_tower_origin/datacenter/game_provider.dart';
import 'package:magic_tower_origin/map/map_entities.dart';
import 'package:magic_tower_origin/map/map_info.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/condition_trigger.dart';
import 'package:magic_tower_origin/role/grow_weapon_role.dart';
import 'package:magic_tower_origin/role/name_role.dart';
import 'package:magic_tower_origin/role/npc_character.dart';
import 'package:magic_tower_origin/role/prop_condition_role.dart';
import 'package:magic_tower_origin/role/prop_role.dart';
import 'package:magic_tower_origin/role/weapon_role.dart';
import 'package:magic_tower_origin/rolemanager/hero_manager.dart';
import 'package:magic_tower_origin/rolemanager/roles_manager.dart';
import 'package:magic_tower_origin/utils/router_heper.dart';
import 'package:magic_tower_origin/utils/toast.dart';
import 'package:magic_tower_origin/view/conversation_view.dart';

/// 英雄 移动事件管理
class HeroEventLogic {
  HeroManager _heroManager;
  RolesManager _rolesManager;
  List<ImageRender> _imageRenders;

  HeroEventLogic(this._heroManager, this._rolesManager, this._imageRenders);

  bool directDell(BuildContext context, TouchDirect direct) {
    int px = _heroManager.hero.imageRender.position[0];
    int py = _heroManager.hero.imageRender.position[1];

    int tempPx = px;
    int tempPy = py;
    if (direct == TouchDirect.left) {
      tempPx = tempPx - 1;
    } else if (direct == TouchDirect.right) {
      tempPx = tempPx + 1;
    } else if (direct == TouchDirect.top) {
      tempPy = tempPy - 1;
    } else if (direct == TouchDirect.bottom) {
      tempPy = tempPy + 1;
    }
    if (tempPx < 0 || tempPx >= MapInfo.sx) {
      tempPx = px;
    }
    if (tempPy < 0 || tempPy >= MapInfo.sy) {
      tempPy = py;
    }

    BaseCharacter bc = _rolesManager.getCharacter(tempPx, tempPy);

    bool needRender = moveLogic(context, direct, px, py, tempPx, tempPy, bc);
    return needRender;
  }

  bool moveLogic(BuildContext context, TouchDirect direct, int ox, int oy,
      int px, int py, Name character) {
    var hero = _heroManager.hero;
    print("moveLogicmoveLogic   $ox  $oy  $px  $py");
    if (_heroManager.hero == null) {
      return false;
    }
    _heroManager.imageIndexSet(direct);
    int fx = ox;
    int fy = oy;

    bool isPassAble = true;
    if (character is ConditionTrigger &&
        direct != null &&
        (px != ox || py != oy)) {
      if (character is PropConditionRole) {
        // 获得道具更新底部道具显示
        character.trigger();
        GameProvider.ofGame(context).update(character);
      } else if (character is NPC) {
        isPassAble = false;
        doNPCTrigger(context, character, () {
          if (character.triggerThanDismiss) {
            _imageRenders.remove(_rolesManager.remove(px, py).imageRender);
          }
        });
      }
    } else if (character is PropRole) {
      _imageRenders.remove(_rolesManager.remove(px, py).imageRender);
      hero.addEquipment(character);
      _toastProp(character);
    } else if (character is WeaponRole) {
      _imageRenders.remove(_rolesManager.remove(px, py).imageRender);
      if (character is GrowWeaponRole) {
        hero.abilityEntry.merge(character.abilityEntry);
        _toastGrow(character);
      } else {
        hero.addEquipment(character);
        _toastWeapon(character);
      }
    } else if (character is AbilityCharacter) {
      isPassAble = _heroManager.compare(character);
      if (!isPassAble) {
        _toastEnemy(character);
      }
      if (isPassAble) {
        _imageRenders.remove(_rolesManager.remove(px, py).imageRender);
      }
    } else if (character is BaseCharacter) {
      isPassAble = character.abilityEntry.passable;
    }
    if (isPassAble) {
      fx = px;
      fy = py;
    }

    final position = hero.imageRender.position;
    position[0] = fx;
    position[1] = fy;
    return isPassAble;
  }

  void _toastEnemy(AbilityCharacter character) {
    if (character.abilityEntry.yKey > 0) {
      Toast.show("开不了门~ 需要一把${ME.getYKey().name}");
    }
    if (character.abilityEntry.bKey > 0) {
      Toast.show("开不了门~ 需要一把${ME.getBKey().name}");
    }
    if (character.abilityEntry.rKey > 0) {
      Toast.show("开不了门~ 需要一把${ME.getRKey().name}");
    } else {
      Toast.show("没有足够的能力打败怪兽");
    }
  }

  void _toastGrow(GrowWeaponRole character) {
    if (character.abilityEntry.yKey > 0) {
      Toast.show("获得${character.abilityEntry.yKey}把${character.name}");
    } else if (character.abilityEntry.bKey > 0) {
      Toast.show("获得${character.abilityEntry.bKey}把${character.name}");
    } else if (character.abilityEntry.rKey > 0) {
      Toast.show("获得${character.abilityEntry.rKey}把${character.name}");
    } else if (character.abilityEntry.attack > 0) {
      Toast.show("获得${character.name}${character.abilityEntry.attack}");
    } else if (character.abilityEntry.defend > 0) {
      Toast.show("获得${character.name}${character.abilityEntry.defend}");
    } else if (character.abilityEntry.life > 0) {
      Toast.show("获得${character.name}${character.abilityEntry.life}");
    } else if (character.abilityEntry.experience > 0) {
      Toast.show("获得${character.name}${character.abilityEntry.experience}");
    }
  }

  void _toastProp(PropRole character) {
    Toast.show("获得道具 ${character.name}");
  }

  void _toastWeapon(WeaponRole character) {
    Toast.show("获得武器 ${character.name}");
  }

  void cutProp(int type) {
    var hero = _heroManager.hero;
    if (hero == null) {
      return;
    }
    for (var pr in hero.getProps()) {
      if (pr.abilityEntry.propType == type) {
        var times = --pr.abilityEntry.times;
        print("cutPropcutPropcutPropcutProp    $times");
        if (times <= 0) {
          hero.equipment.remove(pr);
          break;
        }
      }
    }
  }

  void doNPCTrigger(BuildContext context, NPC npc, VoidCallback onTrigger) {
    RouterHelper.routeDialog(context,
        showDuring: 10,
        barrierDismissible: false,
        layout: Conversation(npc.name, npc.message, () {
          onTrigger();
          npc.trigger();
        }));
  }
}
