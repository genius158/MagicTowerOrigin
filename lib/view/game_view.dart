import 'package:flutter/material.dart';
import 'package:magic_tower_origin/ability/prop_entry.dart';
import 'package:magic_tower_origin/ability/prop_type.dart';
import 'package:magic_tower_origin/control/control_touch.dart';
import 'package:magic_tower_origin/datacenter/game_notify_flag.dart';
import 'package:magic_tower_origin/datacenter/game_provider.dart';
import 'package:magic_tower_origin/map/file_path_manager.dart';
import 'package:magic_tower_origin/map/map_file_contol.dart';
import 'package:magic_tower_origin/map/map_info.dart';
import 'package:magic_tower_origin/role/prop_level.dart';
import 'package:magic_tower_origin/role/prop_role.dart';
import 'package:magic_tower_origin/rolemanager/character_manager.dart';
import 'package:magic_tower_origin/utils/context_helper.dart';
import 'package:magic_tower_origin/utils/router_heper.dart';
import 'package:magic_tower_origin/utils/toast.dart';
import 'package:magic_tower_origin/view/game_control_render_view.dart';
import 'package:magic_tower_origin/view/monster_book_dialog.dart';

import 'package:rxdart/rxdart.dart';

class GameView extends StatefulWidget {
  GameView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _GameViewState();
  }
}

class _GameViewState extends State<GameView> with WidgetsBindingObserver {
  CharacterManager _characterManager = new CharacterManager();
  bool _canLoadMapRes = true;
  bool _needLoad = true;

  @override
  Widget build(BuildContext context) {
    print("GameView       GameViewGameViewGameViewGameViewGameView");

    _tryLoadRes(context, null, withSaveCache: false);
    return GameControlRenderView(
        _characterManager.imageRenders, _onDirectChange, _onRender);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ContextHelper.withCxt(context, (_) {
      GameProvider.ofGame(context).value.listen(_onListen);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _characterManager.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _characterManager.saveCache(context);
    }
  }

  void _tryLoadRes(BuildContext context, int level,
      {bool withSaveCache = true}) {
    if (!(_canLoadMapRes && (level != null || _needLoad))) {
      return;
    }
    _needLoad = false;
    _canLoadMapRes = false;
    print("tryLoadRes tryLoadRes tryLoadRes   ------------------------");
    ContextHelper.withCxt(context, (_) {
      int currentLevel;
      if (level != null) {
        currentLevel = level;
      }
      if (withSaveCache) {
        _characterManager.saveCache(context, levelCache: true).then((_) {
          _loadResExecute(context, currentLevel);
        });
      } else {
        _loadResExecute(context, currentLevel);
      }
    });
  }

  void _loadResExecute(BuildContext context, int currentLevel) {
    if (currentLevel != null) {
      _loadRes(context, currentLevel);
      return;
    }
    Observable.fromFuture(MapFileControl.getCurLevel(context,
            enableInner: true, isMain: true))
        .listen((level) {
      _loadRes(context, level);
    });
  }

  void _loadRes(BuildContext context, int level) {
    _characterManager.loadImages(context, level).listen((_) {
      GameProvider.ofHero(context).update(_characterManager.heroManager.hero);
      print("loadResloadResload  success  --------------------------");
      setState(() {});
      _canLoadMapRes = true;
    });
  }

  void _onListen(propBc) {
    ContextHelper.withCxt(context, (_) {
      if (propBc is PropLevel) {
        if (propBc.curLevel < 0) {
          Toast.show("不存在小于1的关卡");
          return;
        }
        MapInfo.curLevel = propBc.curLevel;
        _tryLoadRes(context, propBc.curLevel);
        return;
      }
      if (propBc is PropRole) {
        PropEntry pe = propBc.abilityEntry;
        if (pe.propType == PropType.ABILITY_BOOK) {
          RouterHelper.routeDialog(context,
              layout: MonsterBookDialog(_characterManager.heroManager.hero,
                  _characterManager.rolesManager.characters));
          return;
        }

        if (pe.propType == PropType.ABILITY_FLY_UP) {
          if (MapInfo.curLevel + 1 >= MapInfo.levelCount) {
            Toast.show("已经是最顶层了~");
            return;
          }
          _characterManager.dellPropType(pe.propType, context);
          MapInfo.curLevel = MapInfo.curLevel + 1;
          _tryLoadRes(context, MapInfo.curLevel);
        } else if (pe.propType == PropType.ABILITY_FLY_DOWN) {
          if (MapInfo.curLevel - 1 < 0) {
            Toast.show("不存在小于1的关卡");
            return;
          }
          _characterManager.dellPropType(pe.propType, context);
          MapInfo.curLevel = MapInfo.curLevel - 1;
          _tryLoadRes(context, MapInfo.curLevel);
        } else {
          _characterManager.dellPropType(pe.propType, context);
        }
        return;
      }

      _gameControl(propBc);
    });
  }

  void _gameControl(propBc) {
    if (!(propBc is GameNotifyFlag)) {
      return;
    }

    if (propBc != GameNotifyFlag.gameMain &&
        propBc != GameNotifyFlag.gameLoadDiy) {
      return;
    }
    String message;
    if (propBc == GameNotifyFlag.gameMain) {
      message = "确定重新开始主关卡";
    } else if (propBc == GameNotifyFlag.gameLoadDiy) {
      message = "确定重新开始自定义关卡";
    }
    RouterHelper.routeDialog(context, title: "提示", message: message,
        onPositive: () {
      Observable.fromFuture(_mapChange(context, propBc)).listen((_) {
        _needLoad = true;
        _tryLoadRes(context, null, withSaveCache: false);
      }, onError: (err) {
        if (propBc == GameNotifyFlag.gameLoadDiy) {
          Toast.show("没有打开读写权限，或者没有自定义地图");
        }
      });
    });
  }

  Future _mapChange(BuildContext context, GameNotifyFlag flag) async {
    String fileCache = await FilePathManager.getTemporaryFilePath();
    if (flag == GameNotifyFlag.gameLoadDiy) {
      String external = await FilePathManager.getExternalFilePath();
      await FilePathManager.setCacheOriginalPathMap(external);
      await MapFileControl.copyMap2Cache(context,
          filePath: external, toFilePath: fileCache);
    } else if (flag == GameNotifyFlag.gameMain) {
      Map<String, dynamic> innerMap =
          await MapFileControl.readInnerMap(context);
      await FilePathManager.setCacheOriginalPathMap(null);
      await MapFileControl.writeJSON(fileCache, innerMap);
    }
  }

  void _onDirectChange(TouchDirect direct) {
    final infoUpdate = _characterManager.directDell(context, direct);
    GameProvider.ofHero(context)
        .setHeroInfo(_characterManager.heroManager.hero);
    if (infoUpdate) {
      GameProvider.ofHero(context).update(_characterManager.heroManager.hero);
    }
    print("onDirectChangeonDirectChange    $direct   $infoUpdate ");
  }

  void _onRender(int value) {
    _characterManager.imageIndex(value);
  }
}
