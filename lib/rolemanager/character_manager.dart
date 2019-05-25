import 'package:flutter/material.dart';
import 'package:magic_tower_origin/ability/prop_type.dart';
import 'package:magic_tower_origin/control/control_touch.dart';
import 'package:magic_tower_origin/datacenter/game_provider.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/map/map_entities.dart';
import 'package:magic_tower_origin/map/map_file_contol.dart';
import 'package:magic_tower_origin/map/map_info.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/prop_level.dart';
import 'package:magic_tower_origin/rolemanager/base_manager.dart';
import 'package:magic_tower_origin/rolemanager/hero_event_logic.dart';
import 'package:magic_tower_origin/rolemanager/hero_manager.dart';
import 'package:magic_tower_origin/rolemanager/roles_manager.dart';
import 'package:rxdart/rxdart.dart';

/// 角色管理类
class CharacterManager {
  /// 英雄
  HeroManager heroManager = new HeroManager();

  /// 其他角色，包括敌人、道具、墙壁等
  RolesManager rolesManager = new RolesManager();

  /// 角色对应的图片资源
  List<ImageRender> imageRenders = new List();

  /// 英雄移动逻辑控制类
  HeroEventLogic _heroEventLogic;

  CharacterManager() {
    _heroEventLogic =
        new HeroEventLogic(heroManager, rolesManager, imageRenders);
  }

  /// 当前关卡数
  int mapLevel;

  /// 上一个关卡数
  int _lastLevel;

  /// 角色对应的图片资源是否已经加载好
  bool _resReady = false;

  /// 加载图片资源
  Observable loadImages(BuildContext context, mapLevel) {
    this._resReady = false;
    this.mapLevel = mapLevel;
    dispose();

    print("loadImages -------- ${imageRenders.length}    $mapLevel");
    List<Observable<List<BaseCharacter>>> observables = new List();
    observables.add(Observable.fromFuture(BaseManager.getImage(ME.getRoad1()))
        .map((data) => getWalls(data)));
    observables.add(MapConvert.parseJsonMap(
            MapFileControl.getRoles(context, mapLevel, enableInner: true))
        .flatMap((d) {
      return rolesManager.loadImages(d);
    }));
    observables.add(MapConvert.parseJsonMap(
            MapFileControl.getHero(context, mapLevel, enableInner: true))
        .flatMap((heros) {
      return heroManager.loadImages(heros);
    }));
    return Observable.concat(observables)
        .bufferCount(observables.length)
        .map((List<List<BaseCharacter>> characterss) {
      for (List<BaseCharacter> characters in characterss) {
        print("Observable.concat    $characters");
        imageRenders.addAll(characters.map((character) {
          return character != null ? character.imageRender : null;
        }).toList());
      }
      _resetHeroPosition(heroManager.hero);

      _lastLevel = mapLevel;
      _resReady = true;
    });
  }

  bool directDell(BuildContext context, TouchDirect direct) {
    // 渲染完成后才可以 继续 游戏
    if (_resReady && direct != null && direct != TouchDirect.none) {
      bool needRender = _heroEventLogic.directDell(context, direct);
      return needRender;
    }
    return false;
  }

  void dispose() {
    heroManager.dispose();
    imageRenders.clear();
    rolesManager.dispose();
  }

  /// 缓存游戏数据
  Future saveCache(BuildContext context,
      {bool levelCache, String filePath}) async {
    if (levelCache != null && levelCache) {
      _resReady = false;
    }
    if (heroManager.hero != null) {
      return MapFileControl.saveCache(
          context, mapLevel, rolesManager.characters,
          filePath: filePath, enableInner: true, hero: heroManager.hero);
    }
  }

  /// 重新设置英雄位置
  void _resetHeroPosition(BaseCharacter hero) {
    for (List<BaseCharacter> lb in rolesManager.characters) {
      for (BaseCharacter b in lb) {
        if (b is PropLevel) {
          if (_lastLevel == null) {
            _lastLevel = mapLevel;
          }
          if (b.offset < 0 && mapLevel >= _lastLevel ||
              mapLevel < _lastLevel && b.offset > 0) {
            if (_heroPositionLogic(
                hero.imageRender.position, b.imageRender.position)) {
              return;
            }
          }
        }
      }
    }
  }

  bool _heroPositionLogic(List<int> hp, List<int> ep) {
    if (_determineHp(hp, ep[0] - 1, ep[1])) {
      return true;
    }
    if (_determineHp(hp, ep[0], ep[1] - 1)) {
      return true;
    }
    if (_determineHp(hp, ep[0] + 1, ep[1])) {
      return true;
    }
    if (_determineHp(hp, ep[0], ep[1] + 1)) {
      return true;
    }
    return false;
  }

  /// 确认英雄初始位置的有效性
  bool _determineHp(List<int> hp, int px, int py) {
    if (px < 0) {
      return false;
    }
    if (px >= MapInfo.sx) {
      return false;
    }
    if (py < 0) {
      return false;
    }
    if (py >= MapInfo.sy) {
      return false;
    }

    if (rolesManager.getCharacter(px, py) == null) {
      hp[0] = px;
      hp[1] = py;
      return true;
    }
    return false;
  }

  /// 实现角色动画
  void imageIndex(int value) {
    rolesManager.imageIndex(value);
  }

  /// 最先加载完成路面
  static List<BaseCharacter> getWalls(BaseCharacter resWall) {
    List<BaseCharacter> finalWalls = List();
    for (int i = 0; i < MapInfo.sx; i++) {
      for (int j = 0; j < MapInfo.sy; j++) {
        BaseCharacter wall = ME.getRoad1();
        wall.imageRender.position[0] = i;
        wall.imageRender.position[1] = j;
        wall.imageRender.imageNodes = resWall.imageRender.imageNodes;
        finalWalls.add(wall);
      }
    }
    return finalWalls;
  }

  /// 处理道具响应
  void dellPropType(int propType, context) {
    switch (propType) {
      case PropType.ABILITY_SYMMETRY:
        var dell = symmetry();
        if (dell) {
          GameProvider.ofHero(context).update(heroManager.hero);
        }
        break;
      case PropType.ABILITY_FLY_UP:
        heroManager.cutProp(PropType.ABILITY_FLY_UP);
        GameProvider.ofHero(context).update(heroManager.hero);
        break;
      case PropType.ABILITY_FLY_DOWN:
        heroManager.cutProp(PropType.ABILITY_FLY_DOWN);
        GameProvider.ofHero(context).update(heroManager.hero);
        break;
    }
  }

  /// 对称道具效果
  bool symmetry() {
    if (!_resReady) {
      return false;
    }
    var position = heroManager.hero.imageRender.position;
    var symmetry = [MapInfo.sx - 1 - position[0], MapInfo.sy - 1 - position[1]];

    bool noEnemy = rolesManager.getCharacter(symmetry[0], symmetry[1]) == null;
    if (noEnemy) {
      position[0] = symmetry[0];
      position[1] = symmetry[1];
      heroManager.cutProp(PropType.ABILITY_SYMMETRY);
      return true;
    }
    return false;
  }
}
