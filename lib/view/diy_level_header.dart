import 'dart:async';

import 'package:flutter/material.dart';

import 'package:magic_tower_origin/config/colors.dart';
import 'package:magic_tower_origin/map/file_path_manager.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/map/map_file_contol.dart';
import 'package:magic_tower_origin/utils/router_heper.dart';
import 'package:magic_tower_origin/view/level_choice_dialog.dart';
import 'package:rxdart/rxdart.dart';

/// diy 页面 头部
class DiyLevelHeader extends StatefulWidget {
  ValueChanged<int> _onLevelChange;
  DiyLevelLogic _onParentDell;

  PublishSubject<List> _subject;

  DiyLevelHeader(this._subject, this._onLevelChange, this._onParentDell);

  @override
  State<StatefulWidget> createState() {
    return _DiyLevelHeaderState();
  }
}

class _DiyLevelHeaderState extends State<DiyLevelHeader> {
  int _level = 0;
  int _startLevel = 0;
  StreamSubscription<List> _levelResetStream;

  @override
  void initState() {
    super.initState();
    _levelResetStream = widget._subject.listen(_onLevelChange);
  }

  @override
  void dispose() {
    super.dispose();
    _levelResetStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorMgr.cr666666(),
        border: Border(
          left: BorderSide(color: ColorMgr.crB57147(), width: 4),
          top: BorderSide(color: ColorMgr.crB57147(), width: 4),
          right: BorderSide(color: ColorMgr.crB57147(), width: 4),
        ),
      ),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              onPressed: () {
                _dellLevel(-1);
              },
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                alignment: Alignment.center,
                height: 20,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                child: Text(
                  "$_level",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: _showLevelChoiceDialog,
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              onPressed: () {
                _dellLevel(1);
              },
            ),
            GestureDetector(
              child: Text(
                "   起始关卡: $_startLevel",
                style: TextStyle(color: Colors.white),
              ),
              onTap: _showLevelStartChoiceDialog,
            )
          ],
        ),
        width: double.infinity,
        height: 40,
      ),
    );
  }

  void _dellLevel(int offset) {
    bool lcAble = widget._onParentDell.levelChangeAble();
    if (!lcAble) {
      return;
    }
    _getLevelCount().then((count) {
      int tempLevel = _level;
      if (_level + offset >= 0) {
        _level += offset;
      }
      if (tempLevel != _level) {
        widget._onLevelChange(_level);
      }
    });
  }

  Future _getLevelCount() async {
    String editFilePath = await FilePathManager.getMapEditCacheFilePath();

    var map;
    try {
      map = await MapFileControl.getMapData(context,
          filePath: editFilePath, enableInner: false);
    } catch (err) {
      map = MapFileControl.getDefaultMap();
    }
    if (map is Map) {
      var levels = map[MapConvert.LEVELS];
      if (levels is List) {
        return levels.length;
      }
    }
    return 0;
  }

  void _showLevelChoiceDialog() async {
    String editPath = await FilePathManager.getMapEditCacheFilePath();
    RouterHelper.routeDialog(context,
        layout: LevelChoiceDialog(editPath, (level) {
          _level = level;
          widget._onLevelChange(level);
        }));
  }

  void _showLevelStartChoiceDialog() async {
    String editPath = await FilePathManager.getMapEditCacheFilePath();
    RouterHelper.routeDialog(context,
        layout: LevelChoiceDialog(editPath, (level) {
          _startLevel = level;
          widget._onParentDell.setStartLevel(level);
          setState(() {});
        }));
  }

  void _onLevelChange(List event) {
    _level = event[0];
    _startLevel = event[1];
    print("_onLevelChange_onLevelChange   $event");
  }
}

abstract class DiyLevelLogic {
  bool levelChangeAble();

  void setStartLevel(int level);
}
