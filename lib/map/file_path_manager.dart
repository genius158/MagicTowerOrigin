import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilePathManager {
  static const String EDIT_CACHE = "editCache";
  static const String DEFAULT_NAME = "map.json";

  static String _curCachePath;
  static Map<String, String> _cacheOriginalPathMap;

  static Future<String> getCurCachePath() async {
    if (_curCachePath != null) {
      return _curCachePath;
    }
    if (_curCachePath == null) {
      _curCachePath = await getTemporaryFilePath();
    }
    return _curCachePath;
  }

  static getCur2OriginalPath(String curPath) async {
    var cacheOriMap = await getCacheOriginalPathMap();
    if (cacheOriMap != null) {
      return cacheOriMap[curPath];
    }
  }

  static getCacheOriginalPathMap() async {
    if (_cacheOriginalPathMap != null) {
      return _cacheOriginalPathMap;
    }
    _cacheOriginalPathMap = new Map();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mapCacheInfo = prefs.getString("cacheOriginalMap");
    try {
      var mapCO = json.decode(mapCacheInfo);
      _cacheOriginalPathMap.addAll(mapCO);
      return _cacheOriginalPathMap;
    } catch (err) {
      print("mapFrom   $err");
      return _cacheOriginalPathMap;
    }
  }

  static setCacheOriginalPathMap(String originalPath) async {
    _cacheOriginalPathMap = await getCacheOriginalPathMap();
    String orgPath = originalPath;
    _cacheOriginalPathMap.putIfAbsent(await getCurCachePath(), () {
      return orgPath;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("cacheOriginalMap", json.encode(_cacheOriginalPathMap));
  }

  static Future<String> getExternalFilePath() async {
    if (Platform.isIOS) {
      Directory add = await getApplicationDocumentsDirectory();
      return add.path + "/orignDIY/" + DEFAULT_NAME;
    }
    Directory esd = await getExternalStorageDirectory();
    return esd.path + "/magicTowerOrgin/" + DEFAULT_NAME;
  }

  static Future<String> getTemporaryFilePath() async {
    Directory add = await getApplicationDocumentsDirectory();
    return add.path + "/" + DEFAULT_NAME;
  }

  static Future<String> getCacheDirectoryPath() async {
    Directory td = await getTemporaryDirectory();
    return td.path;
  }

  static Future<String> getMapEditCacheFilePath() async {
    String cachePath = await getCacheDirectoryPath();
    return cachePath + "/$EDIT_CACHE/" + DEFAULT_NAME;
  }
}
