import 'package:magic_tower_origin/ability/base_entry.dart';

 /// 属性基类
class PropEntry extends BaseEntry<PropEntry> {
  int times = -1;
  int propType;

  PropEntry setTimes(int times) {
    this.times = times;
    return this;
  }

  PropEntry setPropType(int propType) {
    this.propType = propType;
    return this;
  }

  merge(PropEntry other) {
    if (times > 0) {
      times += other.times;
    }
  }

  PropEntry clone() {
    PropEntry propEntry = new PropEntry();
    propEntry.times = times;
    propEntry.propType = propType;
    propEntry.passable = passable;
    propEntry.name = name;
    propEntry.type = type;
    return propEntry;
  }
}
