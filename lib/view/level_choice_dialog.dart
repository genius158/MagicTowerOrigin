import 'package:flutter/material.dart';
import 'package:magic_tower_origin/map/map_convert.dart';
import 'package:magic_tower_origin/map/map_file_contol.dart';
import 'package:magic_tower_origin/utils/context_helper.dart';

/// 关卡选择弹窗
class LevelChoiceDialog extends StatefulWidget {
  String _mapPath;
  ValueChanged<int> _onValueBack;

  LevelChoiceDialog(this._mapPath, this._onValueBack);

  @override
  State<StatefulWidget> createState() {
    return LevelChoiceState();
  }
}

class LevelChoiceState extends State<LevelChoiceDialog> {
  int _levelCount = 1;

  @override
  void initState() {
    super.initState();
    ContextHelper.withCxt(context, (_) {
      loadLevelData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).primaryColor,
      child: ListView(
        children: _getChildren(),
      ),
      height: 150,
    );
  }

  _getChildren() {
    List<Widget> views = List();
    for (var i = 0; i < _levelCount; i++) {
      views.add(_TextLevel(i, _onValueBack));
    }
    views.insert(
        0,
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(
            "已编辑关卡",
            style: TextStyle(color: Colors.white),
          ),
        ));
    return views;
  }

  void loadLevelData() async {
    try {
      Map map =
          await MapFileControl.getMapData(context, filePath: widget._mapPath);
      var levels = map[MapConvert.LEVELS];
      if (levels is List) {
        _levelCount = levels.length;
      }
      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  void _onValueBack(value) {
    Navigator.pop(context);
    widget._onValueBack(value);
  }
}

class _TextLevel extends StatelessWidget {
  ValueChanged _valueChanged;
  int _level = 0;

  _TextLevel(this._level, this._valueChanged);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Text(
          "${_level + 1}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        alignment: Alignment.center,
      ),
      onTap: () {
        _valueChanged(_level);
      },
    );
  }
}
