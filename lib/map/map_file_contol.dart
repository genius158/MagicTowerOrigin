import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:magic_tower_origin/map/file_path_manager.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/map/map_entities.dart';
import 'package:magic_tower_origin/map/map_info.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/base_character.dart';

/// map entities 地图元素管理
class MapFileControl {
  static getRoles(BuildContext context, level,
      {String filePath, bool enableInner, String subFilePath}) async {
    return await _getCharacterData(context, level, MapConvert.ROLES,
        filePath: filePath, enableInner: enableInner, subFilePath: subFilePath);
  }

  static getPHero(BuildContext context, level,
      {String filePath, bool enableInner, String subFilePath}) async {
    return await _getCharacterData(context, level, MapConvert.P_HERO,
        filePath: filePath, enableInner: enableInner, subFilePath: subFilePath);
  }

  static getHero(BuildContext context, level,
      {String filePath,
      bool enableInner,
      String subFilePath,
      bool withDefaultPosition}) async {
    var map = await getMapData(context,
        filePath: filePath, enableInner: enableInner, subFilePath: subFilePath);
    var hero = map[MapConvert.HERO];
    var pHero = await _getCharacterData(context, level, MapConvert.P_HERO,
        filePath: filePath, enableInner: enableInner, subFilePath: subFilePath);
    if (pHero == null) {
      if (withDefaultPosition ?? true) {
        hero[MapConvert.PX] = 0;
        hero[MapConvert.PY] = 0;
      }
    } else {
      hero[MapConvert.PX] = pHero[MapConvert.PX];
      hero[MapConvert.PY] = pHero[MapConvert.PY];
      if (hero is Map) {
        hero.putIfAbsent(MapConvert.TYPE, () => ME.hero);
      }
    }
    print("herop herop herop herop herop herop   $hero");

    return [hero];
  }

  static _getCharacterData(BuildContext context, int level, String node,
      {String filePath, bool enableInner, String subFilePath}) async {
    var map = await getMapData(context,
        filePath: filePath, enableInner: enableInner, subFilePath: subFilePath);
    if (map == null) {
      return null;
    }
    List mapLevels = map[MapConvert.LEVELS];
    if (mapLevels != null && mapLevels.length > level && level >= 0) {
      return mapLevels[level][node];
    }
    return null;
  }

  static Future<int> getCurLevel(BuildContext context,
      {String filePath,
      bool enableInner,
      String subFilePath,
      bool isMain}) async {
    var map = await getMapData(context,
        filePath: filePath, enableInner: enableInner, subFilePath: subFilePath);
    isMain = isMain ?? false;
    if (isMain) {
      MapInfo.sx = map[MapConvert.SX] ?? MapInfo.sx;
      MapInfo.sy = map[MapConvert.SY] ?? MapInfo.sy;
      MapInfo.curLevel = map[MapConvert.CUR_LEVEL];
      if (map[MapConvert.LEVELS] is List) {
        MapInfo.levelCount = (map[MapConvert.LEVELS] as List).length;
      }
    }

    return map[MapConvert.CUR_LEVEL];
  }

  /// enableInner 是否使用内部地图
  static getMapData(BuildContext context,
      {String filePath, bool enableInner, String subFilePath}) async {
    if (filePath == null) {
      filePath = await FilePathManager.getCurCachePath();
      if (filePath == null) {
        filePath = await FilePathManager.getCur2OriginalPath(filePath);
      }
    }
    enableInner = enableInner ?? false;
    if (enableInner) {
      try {
        return await readMapFromFile(filePath);
      } catch (err) {
//        print(err.toString());
        return await readInnerMap(context);
      }
    } else {
      return await readMapFromFile(filePath);
    }
  }

  /// 载入内置地图
  static Future<Map<String, dynamic>> readInnerMap(BuildContext context) async {
    var jsonData =
        await DefaultAssetBundle.of(context).loadString('innermap/map.json');
    return json.decode(jsonData);
  }

  /// readMapFromFile
  static Future readMapFromFile(String filePath) async {
    File mapFile = File(filePath);
    return await readJSON(mapFile.path);
  }

  /// write map
  static Future writeMap2File(String map, String filePath) async {
    File mapFile = File(filePath);
    Directory appDocDir = mapFile.parent;
    bool isDirExists = await appDocDir.exists();
    if (!isDirExists) {
      await appDocDir.create();
    }
    bool isExists = await mapFile.exists();
    if (!isExists) {
      await mapFile.create();
    }
    await mapFile.writeAsString(map, flush: true);
    print("writeMap2File     success success success success");
    return;
  }

  /// 读取 json 数据
  static readJSON(String filePath) async {
    var file = File(filePath);
    var str = await file.readAsString();
    Map<String, dynamic> data = json.decode(str);
    print("readJSON ------------------------ $data    ");
    return data;
  }

  /// 写入 json 数据
  static writeJSON(String filePath, mapData) async {
    try {
      var file = File(filePath);
      bool isExists = await file.exists();
      if (isExists) {
        await file.create();
      }
      return file.writeAsString(json.encode(mapData), flush: true);
    } catch (err) {
      print(err);
    }
  }

  /// 写入 json 数据
  static deleteFile(String filePath) async {
    try {
      var file = File(filePath);
      bool isExists = await file.exists();
      if (isExists) {
        await file.delete();
      }
    } catch (err) {
      print(err);
    }
  }

  static Future saveCache(
      BuildContext context, int mapLevel, List<List<BaseCharacter>> roles,
      {int startLevel,
      String filePath,
      String subFilePath,
      List heroP,
      AbilityCharacter hero,
      bool enableInner}) async {
    filePath = filePath ?? await FilePathManager.getTemporaryFilePath();
    subFilePath =
        subFilePath ?? await FilePathManager.getCur2OriginalPath(filePath);
    var mapData;
    try {
      mapData = await getMapData(context,
          filePath: filePath,
          subFilePath: subFilePath,
          enableInner: enableInner);
    } catch (err) {
      print("saveCache  $err");
    }
    if (mapData == null) {
      mapData = getDefaultMap();
    }
    if (startLevel != null) {
      mapData[MapConvert.CUR_LEVEL] = startLevel;
    }
    if (hero != null) {
      mapData[MapConvert.HERO] = hero.jsonData();
    }
    if (mapLevel != null && roles != null) {
      List levels = mapData[MapConvert.LEVELS];
      if (levels.length <= mapLevel) {
        for (var i = levels.length; i <= mapLevel; i++) {
          if (levels.length <= i) {
            levels.add(getDefaultLevelData());
          }
        }
      }
      mapData[MapConvert.LEVELS][mapLevel][MapConvert.ROLES] =
          MapConvert.back2Original(roles);

      if (heroP != null) {
        mapData[MapConvert.LEVELS][mapLevel][MapConvert.P_HERO][MapConvert.PX] =
            heroP[0];
        mapData[MapConvert.LEVELS][mapLevel][MapConvert.P_HERO][MapConvert.PY] =
            heroP[1];

        print("herop herop herop herop herop herop   $heroP");
      }
    }

    return MapFileControl.writeMap2File(json.encode(mapData), filePath);
  }

  static Future copyMap2Cache(BuildContext context,
      {String filePath, String toFilePath}) async {
    File fileFrom;
    if (toFilePath == null) {
      toFilePath = await FilePathManager.getCurCachePath();
    }
    if (filePath == null) {
      fileFrom = File(await FilePathManager.getCur2OriginalPath(toFilePath));
    } else {
      fileFrom = new File(filePath);
    }

    var mapData = await fileFrom.readAsString();
    if (mapData == null) {
      return Exception("没有找到缓存的地图");
    }
    return await writeMap2File(mapData, toFilePath);
  }

  static Future copyMap2CacheWrapDefault(BuildContext context,
      {String filePath, String toFilePath}) async {
    try {
      return await copyMap2Cache(context,
          filePath: filePath, toFilePath: toFilePath);
    } catch (err) {
      return await writeMap2File(json.encode(getDefaultMap()), toFilePath);
    }
  }

  static Map<String, dynamic> getDefaultMap() {
    return {
      "sx": 13,
      "sy": 13,
      "curLevel": 0,
      "prop": [],
      "hero": {},
      "levels": []
    };
  }

  static getDefaultLevelData() {
    return {"roles": [], "pHero": {}};
  }
}
