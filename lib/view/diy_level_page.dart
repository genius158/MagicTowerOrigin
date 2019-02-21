import 'dart:io';

import 'package:flutter/material.dart';
import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/config/colors.dart';
import 'package:magic_tower_origin/locale/translations_delegate.dart';
import 'package:magic_tower_origin/map/file_path_manager.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/map/map_entities.dart';
import 'package:magic_tower_origin/map/map_file_contol.dart';
import 'package:magic_tower_origin/render/image_node.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/rolemanager/base_manager.dart';
import 'package:magic_tower_origin/rolemanager/character_manager.dart';
import 'package:magic_tower_origin/rolemanager/hero_manager.dart';
import 'package:magic_tower_origin/rolemanager/roles_manager.dart';
import 'package:magic_tower_origin/utils/context_helper.dart';
import 'package:magic_tower_origin/utils/router_heper.dart';
import 'package:magic_tower_origin/utils/toast.dart';
import 'package:magic_tower_origin/view/diy_level_header.dart';
import 'package:magic_tower_origin/view/game_diy_render_view.dart';
import 'package:magic_tower_origin/widget/game_image_text.dart';
import 'package:rxdart/rxdart.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui' as UI show Image;
import 'package:share_extend/share_extend.dart';

class DiyLevelPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DiyLevelState();
}

class DiyLevelState extends State<DiyLevelPage> implements DiyLevelLogic {
  _InnerRolesManger _rolesManager = new _InnerRolesManger();
  HeroManager _heroManager = new HeroManager();
  List<BaseCharacter> _wallCharacterss;
  List<ImageRender> _selectRects;
  List<ImageRender> _imageRenders = new List();

  PublishSubject<int> _subject = PublishSubject<int>();
  PublishSubject<List> _levelsChangeSubject = PublishSubject<List>();

  List<BaseCharacter<BaseEntry>> _allRoles = List();
  int _level = 0;
  bool _isLevelChangeAble = false;
  bool _isLevelEdit = false;
  int _startLevel = 0;

  @override
  void dispose() {
    super.dispose();
    _subject = null;
  }

  @override
  void initState() {
    super.initState();
    ContextHelper.withCxt(context, (_) {
      _initData();
      Observable.timer(1, Duration(milliseconds: 200)).listen((_) {
        _loadCacheMap();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("DiyLevelLayout  DiyLevelLayout  build");
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(Translations.of(context).text("page_diy")),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: SizedBox(
                  child: IconButton(
                    icon: Icon(
                      Icons.input,
                      color: Colors.white,
                    ),
                    onPressed: _onInput,
                  ),
                  width: 30,
                  height: 30,
                ),
              ),
              SizedBox(
                child: IconButton(
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  onPressed: _onSave,
                ),
                width: 30,
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                  child: IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: _onShareMap,
                  ),
                  width: 30,
                  height: 30,
                ),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              DiyLevelHeader(_levelsChangeSubject, _onLevelChange, this),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: ColorMgr.crB57147(), width: 4),
                    color: ColorMgr.cr666666()),
                child: GameDiyRenderView(_imageRenders, _valueChange, _subject),
              ),
              Expanded(
                child: Container(
                    color: ColorMgr.cr9fa0bf(), child: _getAllItemView()),
              ),
            ],
          ),
        ),
        onWillPop: _onWillPop);
  }

  @override
  bool levelChangeAble() {
    print("isAbleisAbleisAbleisAble    $_isLevelChangeAble");
    return _isLevelChangeAble;
  }

  @override
  void setStartLevel(int level) {
    _startLevel = level;
    print("objectobjectobjectobject    $_startLevel");
  }

  void _valueChange(List<Offset> values) {
    _selectRects.clear();
    for (Offset offset in values) {
      ImageRender ir = new ImageRender(_allRoles[0].imageRender.imageNodes);
      ir.position[0] = offset.dx.floor();
      ir.position[1] = offset.dy.floor();
      _selectRects.add(ir);
    }
    _imageRenders.clear();
    _imageRenders.addAll(_getRenderImages());
    _subject.add(1);
  }

  _getRenderImages() {
    List<ImageRender> renderImages = new List();
    renderImages.addAll(_wallCharacterss.map((wc) => wc.imageRender).toList());
    renderImages.addAll(_rolesManager._getRenderImages());
    if (_heroManager.hero != null &&
        _heroManager.hero.imageRender.position[0] != null) {
      renderImages.add(_heroManager.hero.imageRender);
    }
    renderImages.addAll(_selectRects);
    return renderImages;
  }

  _getAllItemView() {
    var children = new List<Widget>();
    for (var role in _allRoles) {
      if (role.type == ME.road1) {
        continue;
      }
      children.add(_ImageAndData(
        role,
        onTap: _onItemSelect,
      ));
    }
    return new GridView.extent(
      //横轴的最大长度
      maxCrossAxisExtent: 60,
      padding: const EdgeInsets.all(4.0),
      children: children,
    );
  }

  void _onItemSelect(BaseCharacter<BaseEntry> ct) {
    if (ct.type == ME.hero) {
      if (_heroManager.hero == null) {
        _heroManager.hero = ME.getHero();
        _heroManager.hero.imageRender = _allRoles[1].imageRender;
      }
      _heroManager.hero.imageRender.position[0] =
          _selectRects[0].position[0] ?? 0;
      _heroManager.hero.imageRender.position[1] =
          _selectRects[0].position[1] ?? 0;
    } else {
      for (ImageRender ir in _selectRects) {
        int px = ir.position[0] ?? 0;
        int py = ir.position[1] ?? 0;
        if (ct.imageRender == _allRoles[0].imageRender) {
          _rolesManager.characters[px][py] = null;
        } else {
          BaseCharacter baseCharacter = ME.getEntity(ct.type);
          baseCharacter.imageRender.position[0] = px;
          baseCharacter.imageRender.position[1] = py;
          baseCharacter.imageRender.imageNodes = ct.imageRender.imageNodes;
          print("getAllItemView   getAllItemView   $px  $py");
          _rolesManager.characters[px][py] = baseCharacter;
        }
      }
    }
    _imageRenders.clear();
    _imageRenders.addAll(_getRenderImages());

    _subject.add(1);
    _isLevelEdit = true;
  }

  /// 相关数据初始化
  void _initData() {
    for (String roleName in ME.getAllRoles()) {
      _allRoles.add(ME.getEntity(roleName));
    }
    _wallCharacterss = CharacterManager.getWalls(_allRoles[1]);

    _allRoles.insert(
        0,
        BaseCharacter(
            new ImageRender([
              ImageNode("images/item_select.png", [1, 1], 0)
            ]),
            null));
    _selectRects = List();
    _selectRects.add(_allRoles[0].imageRender);
  }

  /// 切换关卡 操作 保存 载入
  void _onLevelChange(int level) {
    _isLevelChangeAble = false;
    Observable.fromFuture(FilePathManager.getMapEditCacheFilePath())
        .flatMap((path) => Observable.fromFuture(MapFileControl.saveCache(
            context, this._level, _rolesManager.characters,
            filePath: path,
            heroP: _heroManager.hero == null
                ? null
                : _heroManager.hero.imageRender.position)))
        .flatMap((_) {
      return Observable.fromFuture(FilePathManager.getMapEditCacheFilePath())
          .flatMap((path) {
        _rolesManager.dispose();
        _heroManager.dispose();
        print("herop herop herop herop herop herop   ${_heroManager.hero}");

        return MapConvert.parseJsonMap(
                MapFileControl.getRoles(context, level, filePath: path))
            .flatMap((d) => _rolesManager.loadImages(d))
            .flatMap((_) {
          return MapConvert.parseJsonMap(MapFileControl.getHero(context, level,
                  filePath: path, withDefaultPosition: false))
              .flatMap((d) => _heroManager.loadImages(d));
        });
      });
    }).listen((_) {
      this._level = level;
      _imageRenders.clear();
      _imageRenders.addAll(_getRenderImages());
      setState(() {});
      _isLevelChangeAble = true;
      print("herop herop herop herop herop herop   ${_heroManager.hero}");
    }, onError: (_) {
      _isLevelChangeAble = true;
    });
  }

  /// 初始化，载入diy地图
  void _loadCacheMap({String inputFilePath}) {
    Map<String, UI.Image> imgCache = new Map();
    List<Observable<List<BaseCharacter<BaseEntry>>>> observables = new List();
    observables.add(Observable.fromFuture(
            FilePathManager.getMapEditCacheFilePath())
        .asyncMap((path) async {
      await loadStartLevel(path);
      return path;
    }).flatMap((path) => MapConvert.parseJsonMap(
                    MapFileControl.getRoles(context, _level, filePath: path))
                .flatMap((d) => _rolesManager.loadImages(d))
                .flatMap((_) {
              return MapConvert.parseJsonMap(MapFileControl.getHero(
                      context, _level,
                      filePath: path, withDefaultPosition: false))
                  .flatMap((d) => _heroManager.loadImages(d));
            })));
    observables.add(Observable.fromIterable(_allRoles)
        .flatMap((character) => Observable.fromFuture(
            BaseManager.getImage(character, imgCache: imgCache)))
        .toList()
        .asObservable());
    Observable.fromFuture(_copyInputFile2Cache()).flatMap((_) {
      return Observable.merge(observables).bufferCount(observables.length);
    }).listen((_) {
      imgCache.clear();
      _loadCacheMapThen();
    }, onError: (err) {
      _loadCacheMapThen();
      Toast.show("没有打开读写权限，自定义地图将不会保存");
    });
  }

  _loadCacheMapThen() {
    _imageRenders.clear();
    _imageRenders.addAll(_getRenderImages());
    setState(() {});
    _isLevelChangeAble = true;
    print("_loadCacheMapThen_loadCacheMapThen -----------------  ");
  }

  Future _copyInputFile2Cache({String inputFilePath}) async {
    inputFilePath =
        inputFilePath ?? await FilePathManager.getExternalFilePath();
    String cachePath = await FilePathManager.getMapEditCacheFilePath();
    await MapFileControl.copyMap2CacheWrapDefault(context,
        filePath: inputFilePath, toFilePath: cachePath);
  }

  Future<bool> _onWillPop() async {
    if (!_isLevelEdit) {
      return true;
    }
    RouterHelper.routeDialog(context,
        title: "提示",
        message: "是否需要保存关卡？",
        negativeText: "否",
        onNegative: () {
          Navigator.of(context).pop(true);
        },
        positiveText: "是",
        onPositive: () {
          _onSave().then((_) {
            Navigator.of(context).pop(true);
          }, onError: (err) {
            print("errerrerrerrerr   $err");
          });
        });
    return false;
  }

  Future _onSave() async {
    _isLevelChangeAble = false;
    try {
      String toFilePath = await FilePathManager.getExternalFilePath();
      String filePath = await FilePathManager.getMapEditCacheFilePath();
      await MapFileControl.saveCache(
          context, this._level, _rolesManager.characters,
          filePath: filePath,
          startLevel: _startLevel,
          hero: _heroManager.hero,
          heroP: _heroManager.hero == null
              ? null
              : _heroManager.hero.imageRender.position);
      MapFileControl.copyMap2Cache(context,
              filePath: filePath, toFilePath: toFilePath)
          .then((date) {
        _isLevelChangeAble = true;
        if (date is FileSystemException) {
          Toast.show("确保授予存储权限，不然保存不了哦~");
        } else if (!(date is Exception)) {
          Toast.show("关卡保存成功");
        }
        _isLevelEdit = false;
      }, onError: (err) {
        _isLevelEdit = false;
        _isLevelChangeAble = true;
        if (err is FileSystemException) {
          Toast.show("确保授予存储权限，不然保存不了哦~");
        }
      });
    } catch (err) {
      print("errerrerr     --------  $err");
      _isLevelEdit = false;
      _isLevelChangeAble = true;
      Toast.show("确保授予存储权限，不然保存不了哦~");
    }
  }

  void _onShareMap() async {
    try {
      String path = await FilePathManager.getMapEditCacheFilePath();
      ShareExtend.share(path, "file");
    } catch (err) {
      Toast.show("分享失败");
    }
  }

  void _onInput() async {
    inputDell().then((filePath) {
      _level = 0;
      _startLevel = 0;
      _levelsChangeSubject.add([0, 0]);
      _loadCacheMap(inputFilePath: filePath);
    }, onError: (err) {
      if (err is Exception) {
        Toast.show(err.toString());
        return;
      }
      Toast.show("导入失败");
    });
  }

  Future inputDell() async {
    String filePath;
    try {
      filePath = await FilePicker.getFilePath(
          type: FileType.ANY, fileExtension: 'JSON');
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }

    print("Filepath: $filePath");
    if (filePath == null) {
      throw Exception("文件不存在");
    }
    if (!filePath.endsWith(".json")) {
      throw Exception("文件格式错误");
    }
    return filePath; //on PlatformException
  }

  Future loadStartLevel(String path) async {
    try {
      _startLevel = await MapFileControl.getCurLevel(context, filePath: path);
    } catch (err) {
      _startLevel = 0;
    }
    _levelsChangeSubject.add([0, _startLevel]);
    print("loadStartLevelloadStartLevelloadStartLevel    $path  $_startLevel");
  }
}

class _ImageAndData extends StatelessWidget {
  BaseCharacter character;
  ValueChanged<BaseCharacter> onTap;

  _ImageAndData(this.character, {this.onTap});

  @override
  Widget build(BuildContext context) {
    var imgNodes = character?.imageRender?.imageNodes;
    ImageNode imgNode;
    if (imgNodes != null) {
      imgNode = imgNodes[0];
    }
    return InkWell(
      child: GameImageText(
        imgNode,
        "",
        width: 30,
        height: 30,
        padding: EdgeInsets.only(left: 3, right: 3),
      ),
      onTap: () {
        if (onTap != null) {
          onTap(character);
        }
      },
    );
  }
}

class _InnerRolesManger extends RolesManager {
  _InnerRolesManger() {
    listReady();
  }

  @override
  void dispose() {
    if (characters == null) {
      return;
    }
    for (var i = 0; i < characters.length; i++) {
      if (characters[i] == null) {
        continue;
      }
      for (var j = 0; j < characters[i].length; j++) {
        characters[i][j] = null;
      }
    }
  }

  _getRenderImages() {
    List<ImageRender> roles = new List();
    if (characters != null) {
      for (var rss in characters) {
        for (var rs in rss) {
          if (rs != null) {
            roles.add(rs.imageRender);
          }
        }
      }
    }
    return roles;
  }
}
